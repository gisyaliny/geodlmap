# ===========================================================
# File: R/exports/export.R
# ===========================================================

#' @title Export map as HTML widget
#' @description Export the map as an HTML widget
#' @param filename Output filename
#' @param title Map title
#' @param width Map width
#' @param height Map height
#' @return Filename (invisibly)
#' @export
geodlmap$set("public", "exportMap", function(filename, title = "geodlmap", width = 800, height = 600) {
  if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
    install.packages("htmlwidgets")
    library(htmlwidgets)
  }
  
  # Add title to map if provided
  if (!is.null(title) && title != "") {
    self$map <- self$map %>%
      addControl(
        html = paste0(
          "<div style='background-color: white; padding: 8px; border-radius: 4px;'>",
          title, "</div>"
        ),
        position = "topright"
      )
  }
  
  # Save the map as an HTML widget
  htmlwidgets::saveWidget(
    widget = self$map,
    file = filename,
    selfcontained = TRUE,
    title = title
  )
  
  message(paste("Map exported to", filename))
  return(invisible(filename))
})