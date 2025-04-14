# ===========================================================
# File: R/tools/controls.R
# ===========================================================

#' @title Add layer control to geodlmap
#' @description Add layer control to the map
#' @param position Position on the map
#' @param collapsed Whether the control should be collapsed
#' @param overlay_groups Groups to include as overlays
#' @param base_groups Groups to include as base layers
#' @return geodlmap object (invisibly)
#' @export
geodlmap$set("public", "addLayerControl", function(position = "topright", collapsed = FALSE, 
                          overlay_groups = NULL, base_groups = NULL) {
  # If no overlay groups specified, get all named layers from datasets list
  if (is.null(overlay_groups)) {
    overlay_groups <- names(self$datasets)
  }
  
  # Use the stored basemaps if available, otherwise use defaults
  if (is.null(base_groups)) {
    if (!is.null(self$basemaps) && length(self$basemaps) > 0) {
      base_groups <- self$basemaps
    } else {
      base_groups <- c("OpenStreetMap", "Esri.WorldStreetMap", "Esri.WorldImagery", 
                      "CartoDB.Positron", "CartoDB.DarkMatter", "Stamen.Terrain", 
                      "Stamen.Toner", "Stamen.Watercolor")
    }
  }
  
  # Add the layer control to the map
  self$map <- self$map %>%
    addLayersControl(
      baseGroups = base_groups,
      overlayGroups = overlay_groups,
      options = layersControlOptions(collapsed = collapsed, position = position)
    )
  
  # Make the first basemap visible by default
  if (length(base_groups) > 0) {
    self$map <- self$map %>%
      hideGroup(base_groups[-1])
  }
  
  message("Added layer control to map")
  return(invisible(self))
})
