context("Analysis functions")

test_that("NDVI calculation works correctly", {
  # Skip if raster package is not available
  skip_if_not_installed("raster")
  
  # Create a simple raster stack with NIR and Red bands
  r <- raster::raster(ncol=10, nrow=10)
  raster::values(r) <- 1:100
  nir <- r * 1.5  # Higher values for NIR
  red <- r * 0.8   # Lower values for red
  
  nir_band <- "nir"
  red_band <- "red"
  
  # Create a RasterStack
  s <- raster::stack(nir, red)
  names(s) <- c(nir_band, red_band)
  
  # Calculate NDVI
  ndvi <- calculate_ndvi(s, nir_band = nir_band, red_band = red_band)
  
  # NDVI formula is (NIR - RED) / (NIR + RED)
  # Check that values are in the correct range (-1 to 1)
  expect_true(all(raster::values(ndvi) >= -1 & raster::values(ndvi) <= 1))
  
  # Check a specific calculation
  # For the first cell: (1.5 - 0.8) / (1.5 + 0.8) = 0.7 / 2.3 = 0.3043
  expected_first_value <- (1.5 - 0.8) / (1.5 + 0.8)
  tolerance <- 0.0001
  expect_equal(raster::values(ndvi)[1], expected_first_value, tolerance = tolerance)
}) 