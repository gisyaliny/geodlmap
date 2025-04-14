# ===========================================================
# File: R/zzz.R
# ===========================================================

# Package imports
#' @import leaflet
#' @import leafem
#' @import sf
#' @import raster
#' @import htmltools
#' @import htmlwidgets
#' @import RColorBrewer
#' @import viridisLite
#' @import R6
#' @importFrom leaflet.extras addDrawToolbar removeDrawToolbar
#' @importFrom leaflet.extras2 addMeasurePathToolbar
#' @importFrom jsonlite fromJSON toJSON
NULL

# Package loading script 
#' @title Package loader
#' @description Loads all components of the geodlmap package
#' @keywords internal

# This file ensures modules are loaded in the correct order

# When the package is loaded
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

# When the package is attached
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("geodlmap ", utils::packageVersion("geodlmap"), " loaded successfully.")
  packageStartupMessage("For documentation, run: ?geodlmap")
}

# Re-export the pipe operator
#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL