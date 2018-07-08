#' Limits for 'sf'
#'
#' Set scale limits based on the 'bbox' of 'sf' object.
#'
#' @name lims_bbox
#' @param x
#'   An object of \code{sf}.
#'
#' @examples
#' nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' points_sfg <- sf::st_multipoint(as.matrix(expand.grid(x = -90:-70, y = 30:40)))
#' points_sfc <- sf::st_sfc(points_sfg, crs = sf::st_crs(nc))
#'
#' p <- ggplot() +
#'   geom_sf(data = nc, aes(fill = AREA)) +
#'   geom_sf(data = points_sfc)
#'
#' # too wide
#' p
#'
#' # shrink the limits to the bbox of nc
#' p + lims_bbox(nc)
#'
#' @export
lims_bbox <- function(x) {
  if (!inherits(x, "sf") && !inherits(x, "sfc")) {
    stop("x is not an sf object!", call. = FALSE)
  }

  bbox <- sf::st_bbox(x)
  ggplot2::lims(
    x = bbox[c("xmin", "xmax")],
    y = bbox[c("ymin", "ymax")]
  )
}
