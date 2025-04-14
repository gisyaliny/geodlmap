#' @title Add vector layer to geodlmap
#' @description Add a vector data layer to the map
#' @param sf_data Simple features data object
#' @param color Border color
#' @param fill_color Fill color
#' @param stroke_width Border width
#' @param opacity Border opacity
#' @param fill_opacity Fill opacity
#' @param name Layer name
#' @param popup_fields Fields to include in popups
#' @return geodlmap object (invisibly)
#' @export
geodlmap$set("public", "addVectorLayer", function(sf_data, color = "blue", fill_color = "blue", 
                         stroke_width = 1, opacity = 0.8, fill_opacity = 0.6, 
                         name = NULL, popup_fields = NULL) {
  # Generate layer name if not provided
  name <- generate_layer_name(name, self$datasets, "Vector_")
  
  # Create popups if requested
  if (!is.null(popup_fields)) {
    popup_content <- apply(sf_data[, popup_fields], 1, function(row) {
      paste0(
        "<div style='max-width: 300px;'>",
        paste(
          sapply(seq_along(popup_fields), function(i) {
            paste0("<strong>", popup_fields[i], ":</strong> ", row[i])
          }),
          collapse = "<br/>"
        ),
        "</div>"
      )
    })
  } else {
    popup_content = NULL
  }
  
  # Add to map based on geometry type
  geom_type <- sf::st_geometry_type(sf_data)[1]
  
  if (geom_type %in% c("POINT", "MULTIPOINT")) {
    self$map <- self$map %>%
      addCircleMarkers(
        data = sf_data,
        color = color,
        fillColor = fill_color,
        radius = 5,
        stroke = TRUE,
        weight = stroke_width,
        opacity = opacity,
        fillOpacity = fill_opacity,
        popup = popup_content,
        group = name
      )
  } else if (geom_type %in% c("LINESTRING", "MULTILINESTRING")) {
    self$map <- self$map %>%
      addPolylines(
        data = sf_data,
        color = color,
        weight = stroke_width,
        opacity = opacity,
        popup = popup_content,
        group = name
      )
  } else if (geom_type %in% c("POLYGON", "MULTIPOLYGON")) {
    self$map <- self$map %>%
      addPolygons(
        data = sf_data,
        color = color,
        weight = stroke_width,
        opacity = opacity,
        fillColor = fill_color,
        fillOpacity = fill_opacity,
        popup = popup_content,
        group = name
      )
  }
  
  # Store reference
  self$datasets[[name]] <- list(
    data = sf_data,
    color = color,
    fill_color = fill_color,
    type = "vector"
  )
  
  message(paste("Added vector layer:", name))
  return(invisible(self))
})
