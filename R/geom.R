#' Label and Text 'Geom's
#'
#' Provides label and text \code{geom}s that automatically retrieve the sf object's coordinates.
#'
#' @name geom_sf_label
#' @importFrom ggplot2 stat
#' @inheritParams ggplot2::geom_label
#' @param ...
#'   Other arguments passed to the underlying function.
#' @param fun.geometry
#'   A function that takes a \code{sfc} object and returns a
#'   \code{sfc_POINT} with the same length as the input (e.g. \link[sf]{st_point_on_surface}).
#'
#' @details
#' These functions are thin wrappers of usual geoms like \code{geom_label()}, the only difference is that
#' they use \code{StatSfCoordinates} for \code{stat}. More precisely:
#'
#' \itemize{
#'   \item \code{geom_sf_label()} is the thin wrapper of \link[ggplot2]{geom_label}.
#'   \item \code{geom_sf_text()} is the thin wrapper of \link[ggplot2]{geom_text}.
#'   \item \code{geom_sf_label_repel()} is the thin wrapper of \link[ggrepel]{geom_label_repel}.
#'   \item \code{geom_sf_text_repel()} is the thin wrapper of \link[ggrepel]{geom_text_repel}.
#' }
#'
#' @section Computed variables
#' Depending on the type of given sfc object, some variables between \code{X}, \code{Y}, \code{Z}
#' and \code{M} are available. Please read Esamples section how to use these.
#'
#' @examples
#' nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' # st_point_on_surface may not give correct results for longitude/latitude data
#' nc_3857 <- sf::st_transform(nc, 3857)
#'
#' # geom_label() for sf
#' ggplot(nc_3857[1:3, ]) +
#'   geom_sf(aes(fill = AREA)) +
#'   geom_sf_label(aes(label = NAME))
#'
#' # ggrepel::geom_label_repel() for sf
#' ggplot(nc_3857[1:3, ]) +
#'   geom_sf(aes(fill = AREA)) +
#'   geom_sf_label_repel(
#'     aes(label = NAME),
#'     # additional parameters are passed to geom_label_repel()
#'     nudge_x = -5, nudge_y = -5, seed = 10
#'   )
#'
#' # Of course, you can use StatSfCoordinates with any geoms.
#' ggplot(nc_3857[1:3, ]) +
#'   geom_sf(aes(fill = AREA)) +
#'   geom_point(aes(geometry = geometry,stat(X), stat(Y)),
#'              stat = StatSfCoordinates,
#'              fun.geometry = sf::st_centroid,
#'              colour = "white", size = 10)
NULL

#' @rdname geom_sf_label
#' @export
StatSfCoordinates <- ggplot2::ggproto(
  "StatSfCoordinates", ggplot2::Stat,
  compute_group = function(data, scales, fun.geometry) {
    points_sfc <- fun.geometry(data$geometry)
    coordinates <- sf::st_coordinates(points_sfc)
    data <- cbind(data, coordinates)

    data
  },

  default_aes = ggplot2::aes(x = stat(X), y = stat(Y)),
  required_aes = c("geometry")
)

geom_sf_label_variants <- function(mapping = NULL,
                                   data = NULL,
                                   fun.geometry,
                                   geom_fun,
                                   ...) {
  if (is.null(mapping$geometry)) {
    geometry_col <- attr(data, "sf_column") %||% "geometry"
    mapping$geometry <- as.name(geometry_col)
  }

  geom_fun(
    mapping = mapping,
    data = data,
    stat = StatSfCoordinates,
    fun.geometry = fun.geometry,
    ...
  )
}

#' @name geom_sf_label
#' @export
geom_sf_label <- function(mapping = NULL,
                          data = NULL,
                          fun.geometry = sf::st_point_on_surface,
                          ...) {
  geom_sf_label_variants(
    mapping = mapping,
    data = data,
    fun.geometry = fun.geometry,
    geom_fun = ggplot2::geom_label,
    ...
  )
}

#' @name geom_sf_label
#' @export
geom_sf_text <- function(mapping = NULL,
                          data = NULL,
                          fun.geometry = sf::st_point_on_surface,
                          ...) {
  geom_sf_label_variants(
    mapping = mapping,
    data = data,
    fun.geometry = fun.geometry,
    geom_fun = ggplot2::geom_text,
    ...
  )
}


#' @name geom_sf_label
#' @export
geom_sf_label_repel <- function(mapping = NULL,
                                data = NULL,
                                fun.geometry = sf::st_point_on_surface,
                                ...) {
  geom_sf_label_variants(
    mapping = mapping,
    data = data,
    fun.geometry = fun.geometry,
    geom_fun = ggrepel::geom_label_repel,
    ...
  )
}

#' @name geom_sf_label
#' @export
geom_sf_text_repel <- function(mapping = NULL,
                                data = NULL,
                                fun.geometry = sf::st_point_on_surface,
                                ...) {
  geom_sf_label_variants(
    mapping = mapping,
    data = data,
    fun.geometry = fun.geometry,
    geom_fun = ggrepel::geom_text_repel,
    ...
  )
}
