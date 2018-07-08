context("lims")

a <- sf::st_sfc(sf::st_point(0:1), sf::st_point(1:2))

test_that("lims_bbox() works", {
  l1 <- lims(x = 0:1, y = 1:2)
  l2 <- lims_bbox(a)

  expect_equal(l1, l2)
})
