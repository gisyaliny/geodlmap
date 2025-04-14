# ===========================================================
# File: R/layers/raster.R
# ===========================================================

#' @title Add raster layer to geodlmap
#' @description Add a raster data layer to the map
#' @param raster_data Raster object to add to the map
#' @param palette Color palette to use
#' @param name Name for the layer
#' @param opacity Opacity of the layer
#' @return geodlmap object (invisibly)
#' @export
geodlmap$set("public", "addRasterLayer", function(raster_data, palette = "viridis", name = NULL, opacity = 0.8) {
  # Generate layer name if not provided
  name <- generate_layer_name(name, self$datasets, "Layer_")
  
  # Create color palette
  pal <- create_color_palette(palette, values(raster_data))
  
  # Add to map
  self$map <- self$map %>%
    addRasterImage(
      raster_data, 
      colors = pal, 
      opacity = opacity,
      group = name
    ) %>%
    addLegend(
      position = "bottomright",
      pal = pal,
      values = values(raster_data),
      title = name,
      group = name
    )
  
  # Store reference
  self$datasets[[name]] <- list(
    data = raster_data,
    palette = palette,
    type = "raster"
  )
  
  message(paste("Added raster layer:", name))
  return(invisible(self))
})