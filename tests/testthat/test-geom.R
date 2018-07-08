context("geom")

nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
polygon_sf <- head(nc, 3)

suppressWarnings(
  polygon_centroids_sfc <- sf::st_point_on_surface(polygon_sf$geometry)
)
labels_df <- as.data.frame(sf::st_coordinates(polygon_centroids_sfc))
labels_df$NAME <- polygon_sf$NAME

test_that("geom_sf_label() works", {
  p <- ggplot(polygon_sf)

  p1 <- p + geom_label(data = labels_df, aes(X, Y, label = NAME))
  p2 <- p + geom_sf_label(aes(label = NAME))

  p1_built <- ggplot_build(p1)
  suppressWarnings(
    p2_built <- ggplot_build(p2)
  )

  expect_equal(p1_built$data[[1]][, c("x", "y", "label")],
               p2_built$data[[1]][, c("x", "y", "label")])


  p3 <- p + ggrepel::geom_label_repel(data = labels_df, aes(X, Y, label = NAME), seed = 10)
  p4 <- p + geom_sf_label_repel(aes(label = NAME), seed = 10)

  p3_built <- ggplot_build(p3)
  suppressWarnings(
    p4_built <- ggplot_build(p4)
  )

  expect_equal(p3_built$data[[1]][, c("x", "y", "label")],
               p4_built$data[[1]][, c("x", "y", "label")])
})
