# ===========================================================
# File: R/analysis/ndvi.R
# ===========================================================

#' @title Calculate NDVI
#' @description Calculate Normalized Difference Vegetation Index from raster bands
#' @param raster_data Multi-band raster data
#' @param nir_band NIR band index or name
#' @param red_band Red band index or name
#' @param output_name Name for output raster
#' @return NDVI raster
#' @export
calculate_ndvi <- function(raster_data, nir_band, red_band, output_name = "NDVI") {
  if (!inherits(raster_data, "RasterStack") && !inherits(raster_data, "RasterBrick")) {
    stop("Input must be a RasterStack or RasterBrick with multiple bands")
  }
  
  if (is.numeric(nir_band) && is.numeric(red_band)) {
    nir <- raster_data[[nir_band]]
    red <- raster_data[[red_band]]
  } else if (is.character(nir_band) && is.character(red_band)) {
    if (!(nir_band %in% names(raster_data)) || !(red_band %in% names(raster_data))) {
      stop("Band names not found in raster")
    }
    nir <- raster_data[[nir_band]]
    red <- raster_data[[red_band]]
  } else {
    stop("Band specifications must be either both numeric or both character")
  }
  
  # Calculate NDVI
  ndvi <- (nir - red) / (nir + red)
  names(ndvi) <- output_name
  return(ndvi)
}