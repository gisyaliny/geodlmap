# Timelapse widget 
#' @title Create timelapse widget
#' @description Create a timelapse animation widget from a raster stack
#' @param raster_stack Multi-layer raster stack for animation
#' @param palette Color palette to use
#' @param frame_delay Delay between frames in milliseconds
#' @param layer_names Names for each layer/frame
#' @param opacity Layer opacity
#' @return HTML widget with timelapse animation
#' @export
geodlmap$set("public", "createTimelapseWidget", function(raster_stack, palette = "viridis", frame_delay = 1000, 
                                layer_names = NULL, opacity = 0.8) {
  # Generate a unique ID for the widget
  widget_id <- paste0("timelapse_", sample(1000:9999, 1))
  
  # If layer names not provided, use indices
  if (is.null(layer_names)) {
    layer_names <- paste0("Layer_", 1:nlayers(raster_stack))
  }
  
  # Create color palette
  if (palette %in% c("viridis", "magma", "inferno", "plasma")) {
    pal <- leaflet::colorNumeric(palette, values(raster_stack), na.color = "transparent")
  } else {
    pal <- leaflet::colorNumeric(brewer.pal(9, palette), values(raster_stack), na.color = "transparent")
  }
  
  # Create the HTML widget structure
  timelapse_html <- htmltools::tagList(
    htmltools::tags$div(
      style = "position: relative; width: 100%; height: 600px;",
      # Container for frames
      htmltools::tags$div(
        id = paste0(widget_id, "_frames"),
        style = "position: absolute; top: 0; left: 0; width: 100%; height: 90%;",
        # Create hidden div for each frame
        lapply(1:nlayers(raster_stack), function(i) {
          # Create a leaflet map for each frame
          m <- leaflet() %>%
            addTiles() %>%
            setView(
              lng = mean(extent(raster_stack)[1:2]), 
              lat = mean(extent(raster_stack)[3:4]), 
              zoom = 5
            ) %>%
            addRasterImage(
              raster_stack[[i]], 
              colors = pal, 
              opacity = opacity
            ) %>%
            addLegend(
              "bottomright", 
              pal = pal, 
              values = values(raster_stack[[i]]),
              title = layer_names[i]
            )
          
          htmltools::tags$div(
            id = paste0(widget_id, "_frame_", i),
            style = if(i == 1) "width: 100%; height: 100%;" else "display: none; width: 100%; height: 100%;",
            m
          )
        })
      ),
      # Controls
      htmltools::tags$div(
        style = "position: absolute; bottom: 0; left: 0; width: 100%; height: 10%; 
                display: flex; align-items: center; justify-content: center; 
                background-color: #f8f9fa; padding: 10px;",
        # Previous button
        htmltools::tags$button(
          id = paste0(widget_id, "_prev"),
          class = "btn btn-default",
          style = "margin-right: 10px;",
          onclick = sprintf("switchFrame('%s', 'prev')", widget_id),
          htmltools::tags$i(class = "fa fa-backward"), 
          "Prev"
        ),
        # Play/Pause button
        htmltools::tags$button(
          id = paste0(widget_id, "_play"),
          class = "btn btn-primary",
          style = "margin-right: 10px;",
          onclick = sprintf("togglePlay('%s')", widget_id),
          htmltools::tags$i(class = "fa fa-play"), 
          "Play"
        ),
        # Next button
        htmltools::tags$button(
          id = paste0(widget_id, "_next"),
          class = "btn btn-default",
          style = "margin-right: 20px;",
          onclick = sprintf("switchFrame('%s', 'next')", widget_id),
          htmltools::tags$i(class = "fa fa-forward"), 
          "Next"
        ),
        # Frame slider
        htmltools::tags$input(
          id = paste0(widget_id, "_slider"),
          type = "range",
          min = "1",
          max = as.character(nlayers(raster_stack)),
          value = "1",
          style = "width: 50%; margin-right: 10px;",
          oninput = sprintf("sliderChange('%s', this.value)", widget_id)
        ),
        # Frame counter
        htmltools::tags$div(
          id = paste0(widget_id, "_counter"),
          style = "min-width: 80px; text-align: center;",
          paste("1 /", nlayers(raster_stack))
        )
      )
    ),
    # JavaScript for controlling the timelapse
    htmltools::tags$script(htmltools::HTML(sprintf(
      "
      // Variables for %s widget
      var currentFrame_%s = 1;
      var totalFrames_%s = %d;
      var isPlaying_%s = false;
      var playInterval_%s;

      // Function to show a specific frame
      function showFrame_%s(n) {
        // Hide all frames
        for (var i = 1; i <= totalFrames_%s; i++) {
          document.getElementById('%s_frame_' + i).style.display = 'none';
        }
        // Show current frame
        document.getElementById('%s_frame_' + n).style.display = 'block';
        // Update counter
        document.getElementById('%s_counter').textContent = n + ' / ' + totalFrames_%s;
        // Update slider
        document.getElementById('%s_slider').value = n;
      }

      // Generic functions that will be called from the buttons
      function switchFrame(widgetId, direction) {
        if (widgetId === '%s') {
          if (direction === 'next') {
            currentFrame_%s = currentFrame_%s %% totalFrames_%s + 1;
          } else {
            currentFrame_%s = currentFrame_%s > 1 ? currentFrame_%s - 1 : totalFrames_%s;
          }
          showFrame_%s(currentFrame_%s);
        }
      }

      function togglePlay(widgetId) {
        if (widgetId === '%s') {
          isPlaying_%s = !isPlaying_%s;
          var playButton = document.getElementById('%s_play');
          
          if (isPlaying_%s) {
            playButton.innerHTML = '<i class=\"fa fa-pause\"></i> Pause';
            playInterval_%s = setInterval(function() {
              switchFrame('%s', 'next');
            }, %d);
          } else {
            playButton.innerHTML = '<i class=\"fa fa-play\"></i> Play';
            clearInterval(playInterval_%s);
          }
        }
      }

      function sliderChange(widgetId, value) {
        if (widgetId === '%s') {
          currentFrame_%s = parseInt(value);
          showFrame_%s(currentFrame_%s);
        }
      }
      ",
      widget_id, widget_id, widget_id, nlayers(raster_stack), widget_id, widget_id,
      widget_id, widget_id, widget_id, widget_id, widget_id, widget_id, widget_id,
      widget_id, widget_id, widget_id, widget_id, widget_id, widget_id, widget_id, widget_id,
      widget_id, widget_id, widget_id, widget_id, widget_id, widget_id, widget_id,
      widget_id, frame_delay, widget_id, widget_id, widget_id, widget_id, widget_id
    )))
  )
  
  # Create an HTML widget
  timelapse_widget <- htmlwidgets::createWidget(
    name = "geodlmapTimelapseWidget",
    list(id = widget_id),
    package = "geodlmap",
    elementId = widget_id,
    dependencies = list(
      htmltools::htmlDependency(
        name = "font-awesome",
        version = "5.15.4",
        src = c(href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"),
        stylesheet = "all.min.css"
      )
    )
  )
  
  # Add the HTML content
  timelapse_widget$x$html <- timelapse_html
  
  return(timelapse_widget)
})