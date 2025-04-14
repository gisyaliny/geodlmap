# Visual Test Script for geodlmap
# This script creates a simple interactive app to test different package functions

library(geodlmap)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "geodlmap Test Suite"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Base Map Tests", tabName = "basemaps", icon = icon("map")),
      menuItem("NASA GIBS Tests", tabName = "nasa_gibs", icon = icon("satellite")),
      menuItem("Tools Tests", tabName = "tools", icon = icon("tools")),
      menuItem("Export Tests", tabName = "export", icon = icon("download"))
    )
  ),
  dashboardBody(
    tabItems(
      # Basemap Tests
      tabItem(tabName = "basemaps",
        fluidRow(
          box(
            title = "Basemap Selection",
            status = "primary",
            solidHeader = TRUE,
            width = 3,
            checkboxGroupInput("basemaps", "Select Basemaps:",
                              choices = c("OpenStreetMap" = "OpenStreetMap",
                                         "ESRI World Imagery" = "Esri.WorldImagery",
                                         "CartoDB Light" = "CartoDB.Positron",
                                         "Stamen Terrain" = "Stamen.Terrain"),
                              selected = "OpenStreetMap")
          ),
          box(
            title = "Map Display",
            status = "success",
            solidHeader = TRUE,
            width = 9,
            leafletOutput("basemap_map", height = 500)
          )
        )
      ),
      
      # NASA GIBS Tests
      tabItem(tabName = "nasa_gibs",
        fluidRow(
          box(
            title = "NASA GIBS Settings",
            status = "primary",
            solidHeader = TRUE,
            width = 3,
            selectInput("gibs_product", "Select GIBS Product:",
                       choices = c("MODIS Terra True Color" = "MODIS_Terra_CorrectedReflectance_TrueColor",
                                  "MODIS Aqua True Color" = "MODIS_Aqua_CorrectedReflectance_TrueColor",
                                  "VIIRS DNB" = "VIIRS_SNPP_DayNightBand_At_Sensor_Radiance",
                                  "MODIS Terra Land Surface Temp" = "MODIS_Terra_Land_Surface_Temp_Day"),
                       selected = "MODIS_Terra_CorrectedReflectance_TrueColor"),
            dateInput("gibs_date", "Select Date:", value = Sys.Date() - 1),
            sliderInput("gibs_opacity", "Opacity:", min = 0, max = 1, value = 0.7, step = 0.1),
            actionButton("update_gibs", "Update Layer", icon = icon("sync"))
          ),
          box(
            title = "NASA GIBS Map",
            status = "success",
            solidHeader = TRUE,
            width = 9,
            leafletOutput("gibs_map", height = 500)
          )
        )
      ),
      
      # Tools Tests
      tabItem(tabName = "tools",
        fluidRow(
          box(
            title = "Map Tools",
            status = "primary",
            solidHeader = TRUE,
            width = 3,
            checkboxInput("draw_tools", "Add Draw Tools", value = TRUE),
            checkboxInput("measure_tools", "Add Measure Tools", value = TRUE),
            checkboxInput("layer_control", "Add Layer Control", value = TRUE),
            actionButton("update_tools", "Update Tools", icon = icon("tools"))
          ),
          box(
            title = "Tools Map",
            status = "success",
            solidHeader = TRUE,
            width = 9,
            leafletOutput("tools_map", height = 500)
          )
        )
      ),
      
      # Export Tests
      tabItem(tabName = "export",
        fluidRow(
          box(
            title = "Export Settings",
            status = "primary",
            solidHeader = TRUE,
            width = 3,
            textInput("export_filename", "Filename:", value = "geodlmap_export.html"),
            textInput("export_title", "Map Title:", value = "geodlmap Test Export"),
            actionButton("export_map", "Export Map", icon = icon("download"))
          ),
          box(
            title = "Export Status",
            status = "success",
            solidHeader = TRUE,
            width = 9,
            verbatimTextOutput("export_status")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  # Initialize maps
  basemap_map <- reactiveVal(geodlmap$new())
  gibs_map <- reactiveVal(geodlmap$new())
  tools_map <- reactiveVal(geodlmap$new())
  
  # Update basemap map when selections change
  observe({
    req(input$basemaps)
    map <- geodlmap$new()
    
    for (bm in input$basemaps) {
      map$addBasemap(bm, group = bm)
    }
    
    if (length(input$basemaps) > 1) {
      map$addLayerControl()
    }
    
    basemap_map(map)
  })
  
  # Render basemap map
  output$basemap_map <- renderLeaflet({
    basemap_map()$display()
  })
  
  # Update GIBS map when button is clicked
  observeEvent(input$update_gibs, {
    map <- geodlmap$new()
    map$addBasemap("CartoDB.DarkMatter", group = "Dark Base")
    
    map$addNASAGIBS(
      product = input$gibs_product,
      date = input$gibs_date,
      opacity = input$gibs_opacity,
      name = "GIBS Layer"
    )
    
    map$addLayerControl()
    gibs_map(map)
  })
  
  # Initialize GIBS map
  observe({
    if (is.null(gibs_map()$datasets) || length(gibs_map()$datasets) == 0) {
      map <- geodlmap$new()
      map$addBasemap("CartoDB.DarkMatter", group = "Dark Base")
      
      map$addNASAGIBS(
        product = "MODIS_Terra_CorrectedReflectance_TrueColor",
        date = Sys.Date() - 1,
        opacity = 0.7,
        name = "GIBS Layer"
      )
      
      map$addLayerControl()
      gibs_map(map)
    }
  })
  
  # Render GIBS map
  output$gibs_map <- renderLeaflet({
    gibs_map()$display()
  })
  
  # Update tools map when button is clicked
  observeEvent(input$update_tools, {
    map <- geodlmap$new()
    map$addBasemap("OpenStreetMap", group = "Streets")
    
    if (input$draw_tools) {
      map$addDrawTools()
    }
    
    if (input$measure_tools) {
      map$addMeasureTools()
    }
    
    if (input$layer_control) {
      map$addLayerControl()
    }
    
    tools_map(map)
  })
  
  # Initialize tools map
  observe({
    if (is.null(tools_map()$map)) {
      map <- geodlmap$new()
      map$addBasemap("OpenStreetMap", group = "Streets")
      
      if (input$draw_tools) {
        map$addDrawTools()
      }
      
      if (input$measure_tools) {
        map$addMeasureTools()
      }
      
      if (input$layer_control) {
        map$addLayerControl()
      }
      
      tools_map(map)
    }
  })
  
  # Render tools map
  output$tools_map <- renderLeaflet({
    tools_map()$display()
  })
  
  # Export map when button is clicked
  observeEvent(input$export_map, {
    # Create a map for export
    map <- geodlmap$new()
    map$addBasemap("OpenStreetMap", group = "Streets")
    map$addNASAGIBS(
      product = "MODIS_Terra_CorrectedReflectance_TrueColor",
      date = Sys.Date() - 1,
      opacity = 0.7,
      name = "GIBS Layer"
    )
    map$addLayerControl()
    
    # Export the map
    result <- tryCatch({
      map$exportMap(input$export_filename, title = input$export_title)
      paste0("Map successfully exported to: ", input$export_filename)
    }, error = function(e) {
      paste0("Error exporting map: ", conditionMessage(e))
    })
    
    output$export_status <- renderText({
      result
    })
  })
}

shinyApp(ui, server) 