# ===========================================================
# File: R/layers/external_services.R
# ===========================================================

#' @title Add NASA GIBS layer to geodlmap
#' @description Add a NASA GIBS layer to the map
#' @param product GIBS product ID
#' @param date Date for the imagery
#' @param name Layer name
#' @param opacity Layer opacity
#' @return geodlmap object (invisibly)
#' @export
geodlmap$set("public", "addNASAGIBS", function(product = "MODIS_Terra_CorrectedReflectance_TrueColor", 
                      date = Sys.Date() - 1, name = NULL, opacity = 0.8) {
  # Default name based on product
  if (is.null(name)) {
    name <- paste0(product, "_", format(as.Date(date), "%Y%m%d"))
  }
  
  # Format date for GIBS URL
  date_str <- format(as.Date(date), "%Y-%m-%d")
  
  # GIBS URL pattern
  gibs_url <- sprintf(
    "https://gibs.earthdata.nasa.gov/wmts/epsg3857/best/%s/default/%s/GoogleMapsCompatible_Level9/{z}/{y}/{x}.jpg",
    product, date_str
  )
  
  self$map <- self$map %>%
    addTiles(
      urlTemplate = gibs_url,
      attribution = paste("NASA GIBS |", product, "|", date_str),
      options = tileOptions(
        opacity = opacity,
        minZoom = 1,
        maxZoom = 9
      ),
      group = name
    )
  
  # Store reference
  self$datasets[[name]] <- list(
    type = "nasa_gibs",
    product = product,
    date = date
  )
  
  message(paste("Added NASA GIBS layer:", product, "for", date_str))
  return(invisible(self))
})