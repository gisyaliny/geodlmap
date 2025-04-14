#' @title Create split panel map for comparing two layers
#' @description Create a new map with a side-by-side comparison of two layers
#' @param left_layer Name of the layer to display on the left
#' @param right_layer Name of the layer to display on the right
#' @param label_left Label for the left layer
#' @param label_right Label for the right layer
#' @return A leaflet map with side-by-side comparison
#' @export
geodlmap$set("public", "createSplitMap", function(left_layer, right_layer, label_left = NULL, label_right = NULL) {
  if (!requireNamespace("leaflet.extras2", quietly = TRUE)) {
    install.packages("leaflet.extras2")
    library(leaflet.extras2)
  }
  
  if (is.null(label_left)) {
    label_left <- left_layer
  }
  
  if (is.null(label_right)) {
    label_right <- right_layer
  }
  
  # Check if layers exist
  if (!(left_layer %in% names(self$datasets)) || !(right_layer %in% names(self$datasets))) {
    stop("One or both specified layers don't exist in the map")
  }
  
  # Create a new map for split view
  split_map <- leaflet() %>%
    addTiles(group = "base") %>%
    setView(
      lng = self$map$x$setView[[1]],
      lat = self$map$x$setView[[2]],
      zoom = self$map$x$setView[[3]]
    )
  
  # Add the layers based on their types
  left_data <- self$datasets[[left_layer]]
  right_data <- self$datasets[[right_layer]]
  
  # Helper function to add a layer based on its type
  add_layer_by_type <- function(map, layer_data, layer_name, side) {
    if (layer_data$type == "raster") {
      # Create color palette
      if (layer_data$palette %in% c("viridis", "magma", "inferno", "plasma")) {
        pal <- leaflet::colorNumeric(layer_data$palette, values(layer_data$data), 
                                    na.color = "transparent")
      } else {
        pal <- leaflet::colorNumeric(brewer.pal(9, layer_data$palette), 
                                   values(layer_data$data), 
                                   na.color = "transparent")
      }
      
      map <- map %>%
        addRasterImage(
          layer_data$data,
          colors = pal,
          opacity = 0.8,
          group = side
        )
    } else if (layer_data$type == "vector") {
      # Add vector data
      geom_type <- sf::st_geometry_type(layer_data$data)[1]
      
      if (geom_type %in% c("POINT", "MULTIPOINT")) {
        map <- map %>%
          addCircleMarkers(
            data = layer_data$data,
            color = layer_data$color,
            fillColor = layer_data$fill_color,
            radius = 5,
            stroke = TRUE,
            weight = 1,
            opacity = 0.8,
            fillOpacity = 0.6,
            group = side
          )
      } else if (geom_type %in% c("LINESTRING", "MULTILINESTRING")) {
        map <- map %>%
          addPolylines(
            data = layer_data$data,
            color = layer_data$color,
            weight = 1,
            opacity = 0.8,
            group = side
          )
      } else if (geom_type %in% c("POLYGON", "MULTIPOLYGON")) {
        map <- map %>%
          addPolygons(
            data = layer_data$data,
            color = layer_data$color,
            weight = 1,
            opacity = 0.8,
            fillColor = layer_data$fill_color,
            fillOpacity = 0.6,
            group = side
          )
      }
    } else if (layer_data$type == "nasa_gibs") {
      # Format date for GIBS URL
      date_str <- format(as.Date(layer_data$date), "%Y-%m-%d")
      
      # GIBS URL pattern
      gibs_url <- sprintf(
        "https://gibs.earthdata.nasa.gov/wmts/epsg3857/best/%s/default/%s/GoogleMapsCompatible_Level9/{z}/{y}/{x}.jpg",
        layer_data$product, date_str
      )
      
      map <- map %>%
        addTiles(
          urlTemplate = gibs_url,
          attribution = paste("NASA GIBS |", layer_data$product),
          options = tileOptions(opacity = 0.8),
          group = side
        )
    }
    
    return(map)
  }
  
  # Add layers
  split_map <- add_layer_by_type(split_map, left_data, left_layer, "left")
  split_map <- add_layer_by_type(split_map, right_data, right_layer, "right")
  
  # Add side-by-side control
  split_map <- split_map %>%
    leaflet.extras2::addSidebyside(
      layerId = "sidebyside",
      leftId = "left",
      rightId = "right"
    ) %>%
    addControl(
      html = paste0(
        "<div style='background-color: white; padding: 8px; border-radius: 4px;'>", 
        "<strong style='color:#1E88E5;'>", label_left, "</strong> | <strong style='color:#E53935;'>", 
        label_right, "</strong></div>"
      ),
      position = "bottomleft"
    )
  
  return(split_map)
})