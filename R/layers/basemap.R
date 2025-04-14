# ===========================================================
# File: R/layers/basemap.R
# ===========================================================

#' @title Add basemap to geodlmap
#' @description Add a basemap layer to the map
#' @param provider Provider name from leaflet providers
#' @param group Layer group name
#' @return geodlmap object (invisibly)
#' @export
geodlmap$set("public", "addBasemap", function(provider = "OpenStreetMap", group = NULL) {
  if (is.null(group)) {
    group <- provider
  }
  
  self$map <- self$map %>%
    addProviderTiles(
      provider = provider,
      group = group
    )
  
  # Store the basemap name in the basemaps vector
  self$basemaps <- c(self$basemaps, group)
  
  message(paste("Added basemap:", provider, "as", group))
  return(invisible(self))
})

# Helper function for basemap utilities could be added here