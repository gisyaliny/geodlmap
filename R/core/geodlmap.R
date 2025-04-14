# ===========================================================
# File: R/core/geodlmap.R
# ===========================================================

#' @title geodlmap Class
#' @description R-based Geospatial Mapping Framework for Cloud Environments
#' @importFrom leaflet leaflet addTiles setView
#' @export
geodlmap <- R6::R6Class(
  "geodlmap",
  
  public = list(
    # Properties
    map = NULL,
    datasets = list(),
    basemaps = c(),
    drawn_features = list(),
    
    # Constructor
    #' @description Create a new geodlmap instance
    #' @return geodlmap object
    initialize = function() {
      self$map <- leaflet::leaflet() %>%
        leaflet::addTiles() %>%
        leaflet::setView(lng = 0, lat = 0, zoom = 2)
      
      message("geodlmap initialized successfully")
      return(invisible(self))
    },
    
    # Display the map in a Jupyter/R Markdown environment
    #' @description Display the map in a Jupyter or R Markdown environment
    #' @return The map object for display
    display = function() {
      return(self$map)
    }
    
    # Other methods will be added via $set in their respective module files
  )
)