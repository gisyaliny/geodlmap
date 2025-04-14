context("NASA GIBS integration")

# Ensure necessary packages are loaded
library(leaflet)

test_that("NASA GIBS layer can be added", {
  # Create a map
  myMap <- geodlmap$new()
  
  # Add a GIBS layer
  # Get today's date for testing
  test_date <- Sys.Date() - 1
  test_date_format <- format(as.Date(test_date), "%Y%m%d")
  
  myMap$addNASAGIBS(
    product = "MODIS_Terra_CorrectedReflectance_TrueColor", 
    date = test_date
  )
  
  # The expected dataset name includes the date in format YYYYMMDD
  expected_name <- paste0("MODIS_Terra_CorrectedReflectance_TrueColor_", test_date_format)
  
  # Check that the dataset was added to the map's dataset list
  expect_true(expected_name %in% names(myMap$datasets))
  
  # Check that the dataset has the correct type
  expect_equal(myMap$datasets[[expected_name]]$type, "nasa_gibs")
  expect_equal(myMap$datasets[[expected_name]]$product, "MODIS_Terra_CorrectedReflectance_TrueColor")
})

test_that("NASA GIBS accepts custom name parameter", {
  myMap <- geodlmap$new()
  
  custom_name <- "Custom GIBS Layer"
  myMap$addNASAGIBS(
    product = "MODIS_Terra_CorrectedReflectance_TrueColor", 
    date = Sys.Date() - 1,
    name = custom_name
  )
  
  # Check that the layer with custom name was added
  expect_true(custom_name %in% names(myMap$datasets))
  expect_equal(myMap$datasets[[custom_name]]$type, "nasa_gibs")
}) 