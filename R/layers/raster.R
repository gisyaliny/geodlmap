#' @title Add raster layer to geodlmap
#' @description Add a raster data layer to the map
#' @export
geodlmap$set("public", "addRasterLayer", function(raster_data, palette = "viridis", name = NULL, opacity = 0.8) {
  if (is.null(name)) {
    name <- paste0("Layer_", length(self$datasets) + 1)
  }
  
  # Create color palette
  if (palette %in% c("viridis", "magma", "inferno", "plasma")) {
    pal <- leaflet::colorNumeric(palette, values(raster_data), na.color = "transparent")
  } else {
    pal <- leaflet::colorNumeric(brewer.pal(9, palette), values(raster_data), na.color = "transparent")
  }
  
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