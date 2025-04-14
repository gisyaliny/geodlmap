# Package initialization, dependency management
required_packages <- c("leaflet", "leafem", "sf", "raster", "htmltools", 
                      "htmlwidgets", "RColorBrewer", "viridisLite", "R6",
                      "leaflet.extras", "leaflet.extras2", "jsonlite")

# Install required packages if not already installed
install_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

# Initialize package
.onLoad <- function(libname, pkgname) {
  # Load dependencies
  sapply(required_packages, install_missing)
}

# Package startup message
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("geodlmap loaded successfully. Type ?geodlmap for help.")
}