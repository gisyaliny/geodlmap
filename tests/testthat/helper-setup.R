# Helper setup for all tests
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
library(sf)
library(raster)
library(magrittr)
library(RColorBrewer)
library(viridisLite)
library(htmltools)
library(htmlwidgets)

# Make sure R6 is loaded
library(R6)

# Create a function to check if all required packages are loaded
check_packages <- function() {
  required_packages <- c(
    "leaflet", "leaflet.extras", "leaflet.extras2",
    "sf", "raster", "magrittr", "RColorBrewer", "viridisLite",
    "htmltools", "htmlwidgets", "R6"
  )
  
  missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
  
  if (length(missing_packages) > 0) {
    warning(paste("Missing packages:", paste(missing_packages, collapse = ", ")))
  }
}

# Run the check
check_packages() 