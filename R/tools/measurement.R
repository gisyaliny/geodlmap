#' @title Add measurement tools to geodlmap
#' @description Add measurement tools to the map
#' @return geodlmap object (invisibly)
#' @export
geodlmap$set("public", "addMeasureTools", function() {
  if (!requireNamespace("leaflet.extras", quietly = TRUE)) {
    install.packages("leaflet.extras")
    library(leaflet.extras)
  }
  
  self$map <- self$map %>%
    addMeasure(
      position = "bottomleft",
      primaryLengthUnit = "kilometers",
      secondaryLengthUnit = "miles",
      primaryAreaUnit = "sqkilometers",
      secondaryAreaUnit = "acres"
    )
  
  message("Added measurement tools to map")
  return(invisible(self))
})
