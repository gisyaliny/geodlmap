# Package loading script 
#' @title Package loader
#' @description Loads all components of the geodlmap package
#' @keywords internal

# This file ensures modules are loaded in the correct order

.onLoad <- function(libname, pkgname) {
  # Core modules
  source(system.file("R", "core", "init.R", package = "geodlmap"))
  source(system.file("R", "core", "utils.R", package = "geodlmap"))
  source(system.file("R", "core", "geodlmap.R", package = "geodlmap"))
  
  # Layer modules
  source(system.file("R", "layers", "basemap.R", package = "geodlmap"))
  source(system.file("R", "layers", "raster.R", package = "geodlmap"))
  source(system.file("R", "layers", "vector.R", package = "geodlmap"))
  source(system.file("R", "layers", "external_services.R", package = "geodlmap"))
  
  # Tool modules
  source(system.file("R", "tools", "drawing.R", package = "geodlmap"))
  source(system.file("R", "tools", "measurement.R", package = "geodlmap"))
  source(system.file("R", "tools", "controls.R", package = "geodlmap"))
  
  # Widget modules
  source(system.file("R", "widgets", "split_map.R", package = "geodlmap"))
  source(system.file("R", "widgets", "timelapse.R", package = "geodlmap"))
  
  # Analysis modules
  source(system.file("R", "analysis", "ndvi.R", package = "geodlmap"))
  
  # Export modules
  source(system.file("R", "exports", "export.R", package = "geodlmap"))
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("geodlmap v0.1.0 loaded successfully. Type ?geodlmap for help.")
}