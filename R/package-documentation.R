# Package documentation 
#' geodlmap: R-based Geospatial Mapping Framework
#'
#' @description
#' A comprehensive framework for interactive geospatial mapping in R.
#' This package provides tools for working with raster and vector data,
#' integrating with external services like NASA GIBS, and creating
#' interactive maps with drawing, measurement, and analysis tools.
#'
#' @details
#' The main class provided by this package is \code{\link{geodlmap}}, which
#' serves as the foundation for creating interactive maps. Key
#' features include:
#'
#' \itemize{
#'   \item Support for multiple basemap providers
#'   \item Integration with raster and vector data
#'   \item NASA GIBS satellite imagery
#'   \item Drawing and measurement tools
#'   \item Layer comparison with split view
#'   \item Timelapse animations
#'   \item Easy export to HTML for sharing
#' }
#'
#' @examples
#' \dontrun{
#' # Create a new map
#' myMap <- geodlmap$new()
#'
#' # Add basemaps
#' myMap$addBasemap("Esri.WorldImagery", group = "Satellite")
#' myMap$addBasemap("CartoDB.Positron", group = "Light")
#'
#' # Add NASA GIBS imagery
#' myMap$addNASAGIBS(product = "MODIS_Terra_CorrectedReflectance_TrueColor")
#'
#' # Add tools
#' myMap$addDrawTools()
#' myMap$addMeasureTools()
#' myMap$addLayerControl()
#'
#' # Display the map
#' myMap$display()
#' }
#'
#' @seealso
#' \code{\link{calculate_ndvi}} for calculating vegetation indices.
#'
#' @docType package
#' @name geodlmap-package
NULL

#' @title geodlmap Class Documentation
#' @description Main geodlmap class for creating interactive maps
#' @format An R6 class object
#' @examples
#' \dontrun{
#' myMap <- geodlmap$new()
#' myMap$addBasemap("OpenStreetMap")
#' myMap$display()
#' }
#' @export
NULL