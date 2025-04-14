context("RMap initialization") 
 
test_that("RMap initializes correctly", { 
  myMap <- RMap$new() 
  expect_s3_class(myMap, "RMap") 
}) 
