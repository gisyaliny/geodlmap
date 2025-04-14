context("geodlmap initialization") 

# Ensure necessary packages are loaded
library(leaflet)

test_that("geodlmap initializes correctly", { 
  myMap <- geodlmap$new() 
  expect_s3_class(myMap, "geodlmap") 
}) 
