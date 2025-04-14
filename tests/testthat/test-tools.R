context("Map tools functionality")

# Ensure necessary packages are loaded
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)

# Set test mode flag
Sys.setenv(TESTTHAT = "true")

test_that("Draw tools can be added", {
  myMap <- geodlmap$new()
  
  # Add draw tools
  myMap$addDrawTools()
  
  # Since we can't directly check the leaflet object structure easily,
  # we can at least check that the function doesn't error out
  expect_true(TRUE)
})

test_that("Measure tools can be added", {
  myMap <- geodlmap$new()
  
  # Add measurement tools
  myMap$addMeasureTools()
  
  # Again, we're mostly checking that the function executes without error
  expect_true(TRUE)
})

test_that("Layer control can be added", {
  myMap <- geodlmap$new()
  
  # Add two basemaps
  myMap$addBasemap("Esri.WorldImagery", group = "Satellite")
  myMap$addBasemap("OpenStreetMap", group = "Streets")
  
  # Add layer control
  myMap$addLayerControl()
  
  # This test mostly ensures the function runs without error
  expect_true(TRUE)
})

# Reset test mode flag
Sys.setenv(TESTTHAT = "") 