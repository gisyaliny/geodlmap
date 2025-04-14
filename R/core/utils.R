# ===========================================================
# File: R/core/utils.R
# ===========================================================

#' @title geodlmap Utility Functions
#' @description Common utility functions for geodlmap
#' @keywords internal

#' @title Check layer name
#' @description Generate a unique layer name if none is provided
#' @param name Proposed layer name
#' @param datasets List of existing datasets
#' @param prefix Prefix for auto-generated names
#' @return A unique layer name
#' @keywords internal
generate_layer_name <- function(name = NULL, datasets, prefix = "Layer_") {
  if (is.null(name)) {
    name <- paste0(prefix, length(datasets) + 1)
  }
  return(name)
}

#' @title Create color palette
#' @description Create a color palette for raster visualization
#' @param palette Palette name
#' @param values Raster values
#' @return A color palette function
#' @keywords internal
create_color_palette <- function(palette, values) {
  if (palette %in% c("viridis", "magma", "inferno", "plasma")) {
    pal <- leaflet::colorNumeric(palette, values, na.color = "transparent")
  } else {
    pal <- leaflet::colorNumeric(brewer.pal(9, palette), values, na.color = "transparent")
  }
  return(pal)
}