context("Basemap functionality")

# Ensure necessary packages are loaded
library(leaflet)

test_that("Basemap can be added", {
  myMap <- geodlmap$new()
  
  # Add a basemap
  myMap$addBasemap("Esri.WorldImagery", group = "Satellite")
  
  # Check that the basemap was added
  expect_true("Satellite" %in% myMap$basemaps)
})

test_that("Multiple basemaps can be added", {
  myMap <- geodlmap$new()
  
  # Add multiple basemaps
  myMap$addBasemap("Esri.WorldImagery", group = "Satellite")
  myMap$addBasemap("CartoDB.Positron", group = "Light")
  myMap$addBasemap("OpenStreetMap", group = "Streets")
  
  # Check all basemaps were added
  expect_equal(length(myMap$basemaps), 3)
  expect_true(all(c("Satellite", "Light", "Streets") %in% myMap$basemaps))
}) 