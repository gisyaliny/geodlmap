#' @title Complete geodlmap Example
#' @description Comprehensive example demonstrating geodlmap functionality

# Load the geodlmap package
library(geodlmap)

# Create a new map instance
myMap <- geodlmap$new()

# Add multiple basemaps (only the first one will be visible initially)
myMap$addBasemap("Esri.WorldImagery", group = "Satellite")
myMap$addBasemap("CartoDB.Positron", group = "Light")
myMap$addBasemap("Stamen.Terrain", group = "Terrain") 
myMap$addBasemap("OpenStreetMap", group = "Streets")

# Add NASA GIBS imagery
myMap$addNASAGIBS(
  product = "MODIS_Terra_CorrectedReflectance_TrueColor", 
  date = Sys.Date() - 1,
  name = "MODIS Today",
  opacity = 0.7
)

# Load sample data
# Uncomment and modify these lines as needed with your actual data
# 
# # Add a raster layer
# landcover <- raster::raster("path/to/landcover.tif")
# myMap$addRasterLayer(landcover, palette = "viridis", name = "Land Cover")
# 
# # Add a vector layer
# counties <- sf::st_read("path/to/counties.shp")
# myMap$addVectorLayer(
#   counties, 
#   color = "blue",
#   fill_color = "lightblue", 
#   name = "Counties",
#   popup_fields = c("NAME", "POPULATION")
# )
#
# # Calculate and add NDVI
# sentinel_bands <- raster::stack("path/to/sentinel_bands.tif")
# ndvi <- calculate_ndvi(sentinel_bands, nir_band = "B8", red_band = "B4")
# myMap$addRasterLayer(ndvi, palette = "RdYlGn", name = "NDVI")

# Add drawing and editing tools
myMap$addDrawTools()

# Add measurement tools
myMap$addMeasureTools()

# Add a layer control to switch between basemaps and toggle overlays
myMap$addLayerControl()

# Example of creating a split view map (requires two layers)
# Uncomment if you have multiple layers in your map
# 
# split_view <- myMap$createSplitMap(
#   left_layer = "NDVI", 
#   right_layer = "Land Cover",
#   label_left = "Vegetation Index",
#   label_right = "Land Cover Types"
# )
# split_view  # Display the split view

# Display the map
myMap$display()

# Export to HTML
myMap$exportMap("my_interactive_map.html", title = "geodlmap Interactive Example")