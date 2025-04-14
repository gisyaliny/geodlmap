# Comprehensive test script for geodlmap package

# Load required packages
library(geodlmap)
library(sf)
library(raster)
library(leaflet)  # Explicitly load leaflet
library(magrittr) # For the pipe operator
library(RColorBrewer)

# Test function to print success/failure messages
test_function <- function(name, expr) {
  cat("\nTesting", name, "... ")
  tryCatch({
    expr
    cat("SUCCESS\n")
  }, error = function(e) {
    cat("FAILED\n")
    cat("Error:", conditionMessage(e), "\n")
  })
}

# 1. Test map initialization
test_function("map initialization", {
  myMap <- geodlmap$new()
  if (!inherits(myMap, "geodlmap")) stop("Map initialization failed")
})

# 2. Test basemap functionality
test_function("basemap addition", {
  myMap <- geodlmap$new()
  myMap$addBasemap("Esri.WorldImagery", group = "Satellite")
  myMap$addBasemap("CartoDB.Positron", group = "Light")
  myMap$addBasemap("OpenStreetMap", group = "Streets")
  
  if (length(myMap$basemaps) != 3) stop("Not all basemaps were added")
})

# 3. Test NASA GIBS integration
test_function("NASA GIBS integration", {
  myMap <- geodlmap$new()
  
  myMap$addNASAGIBS(
    product = "MODIS_Terra_CorrectedReflectance_TrueColor", 
    date = Sys.Date() - 1,
    name = "MODIS Today"
  )
  
  if (!"MODIS Today" %in% names(myMap$datasets)) {
    stop("NASA GIBS layer not added correctly")
  }
})

# 4. Test map tools
test_function("map tools", {
  myMap <- geodlmap$new()
  
  # Add tools
  myMap$addDrawTools()
  myMap$addMeasureTools()
  myMap$addLayerControl()
})

# 5. Test analysis functions
test_function("NDVI calculation", {
  # Create a simple raster stack for testing
  r <- raster(nrows=10, ncols=10, xmn=0, xmx=10, ymn=0, ymx=10)
  values(r) <- 1:100
  nir <- r * 1.5
  red <- r * 0.8
  
  s <- stack(nir, red)
  names(s) <- c("nir", "red")
  
  # Calculate NDVI
  ndvi <- calculate_ndvi(s, nir_band = "nir", red_band = "red")
  
  # Verify it's a raster
  if (!inherits(ndvi, "RasterLayer")) {
    stop("NDVI calculation did not return a raster")
  }
})

# 6. Test raster layer addition (if sample data available)
if (file.exists("inst/extdata/sample_raster.tif")) {
  test_function("raster layer addition", {
    myMap <- geodlmap$new()
    r <- raster("inst/extdata/sample_raster.tif")
    myMap$addRasterLayer(r, palette = "viridis", name = "Sample Raster")
    
    if (!"Sample Raster" %in% names(myMap$datasets)) {
      stop("Raster layer not added correctly")
    }
  })
}

# 7. Test vector layer addition (if sample data available)
if (file.exists("inst/extdata/sample_vector.shp")) {
  test_function("vector layer addition", {
    myMap <- geodlmap$new()
    v <- st_read("inst/extdata/sample_vector.shp", quiet = TRUE)
    myMap$addVectorLayer(v, color = "blue", fill_color = "lightblue", name = "Sample Vector")
    
    if (!"Sample Vector" %in% names(myMap$datasets)) {
      stop("Vector layer not added correctly")
    }
  })
}

# 8. Test export functionality
test_function("HTML export", {
  temp_file <- tempfile(fileext = ".html")
  myMap <- geodlmap$new()
  myMap$addBasemap("OpenStreetMap", group = "Streets")
  
  myMap$exportMap(temp_file, title = "Test Map")
  
  if (!file.exists(temp_file)) {
    stop("Map export failed")
  }
  
  # Clean up
  unlink(temp_file)
})

cat("\nAll tests completed!\n") 