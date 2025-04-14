# RMap: R-based Geospatial Mapping Framework

## Overview

RMap is a comprehensive geospatial mapping framework for R, designed to simplify the creation of interactive maps for visualization and analysis. It provides a unified, object-oriented interface to various mapping libraries, with special emphasis on efficiency and usability for cloud-based environments.

## Features

- **Easy to use**: Object-oriented interface with R6 classes
- **Basemap selection**: Multiple basemap providers including OpenStreetMap, Esri, CartoDB, and more
- **Layer management**: Add, remove, and toggle raster and vector layers
- **NASA GIBS integration**: Easily add NASA satellite imagery
- **Interactive tools**: Drawing, editing, and measurement tools
- **Split-view comparison**: Side-by-side comparison of different layers
- **Timelapse animation**: Create animated visualizations from multi-temporal data
- **Analysis functions**: Calculate indices like NDVI from raster data
- **Export capabilities**: Save maps as interactive HTML widgets

## Installation

```r
# Install from GitHub
devtools::install_github("gisyaliny/geodlmap")
```

## Quick Start

```r
library(geodlmap)

# Create a new map
myMap <- geodlmap$new()

# Add basemaps
myMap$addBasemap("Esri.WorldImagery", group = "Satellite")
myMap$addBasemap("CartoDB.Positron", group = "Light")
myMap$addBasemap("OpenStreetMap", group = "Streets")

# Add NASA GIBS imagery
myMap$addNASAGIBS(
  product = "MODIS_Terra_CorrectedReflectance_TrueColor", 
  date = Sys.Date() - 1
)

# Add tools
myMap$addDrawTools()
myMap$addMeasureTools()
myMap$addLayerControl()

# Display the map
myMap$display()

# Export to HTML
myMap$exportMap("my_map.html", title = "My Interactive Map")
```

## Working with Raster Data

```r
# Load a raster file
landcover <- raster::raster("path/to/landcover.tif")

# Add to map with custom palette
myMap$addRasterLayer(landcover, palette = "viridis", name = "Land Cover")
```

## Working with Vector Data

```r
# Load vector data
counties <- sf::st_read("path/to/counties.shp")

# Add to map with custom styling and popup
myMap$addVectorLayer(
  counties, 
  color = "blue",
  fill_color = "lightblue", 
  name = "Counties",
  popup_fields = c("NAME", "POPULATION")
)
```

## Creating a Split View Comparison

```r
# Create a split view comparing two layers
split_view <- myMap$createSplitMap(
  left_layer = "NDVI", 
  right_layer = "Land Cover",
  label_left = "Vegetation Index",
  label_right = "Land Cover Types"
)

# Display the split view
split_view
```

## Creating a Timelapse Animation

```r
# Create a timelapse from a multi-layer raster stack
ndvi_series <- raster::stack("path/to/ndvi_time_series.tif")

# Create dates for the time series
dates <- seq(as.Date("2023-01-01"), by = "month", length.out = nlayers(ndvi_series))
layer_names <- format(dates, "NDVI %b %Y")

# Create timelapse widget
timelapse <- myMap$createTimelapseWidget(
  ndvi_series,
  palette = "RdYlGn",
  frame_delay = 800,
  layer_names = layer_names
)

# Display the timelapse
timelapse
```

## Calculating Vegetation Indices

```r
# Load a multi-band satellite image
sentinel_bands <- raster::stack("path/to/sentinel_bands.tif")

# Calculate NDVI using bands 8 (NIR) and 4 (Red)
ndvi <- calculate_ndvi(sentinel_bands, nir_band = "B8", red_band = "B4")

# Add the NDVI layer to the map
myMap$addRasterLayer(ndvi, palette = "RdYlGn", name = "NDVI")
```

## Documentation

For detailed documentation and examples, see:

- [Function reference](reference/index.html)
- [User guide](articles/user-guide.html)
- [Example gallery](articles/gallery.html)

## Dependencies

RMap depends on the following R packages:

- **leaflet**: Base mapping library
- **sf**: Simple features for vector data
- **raster**: Raster data handling
- **htmlwidgets**: HTML widget creation
- **R6**: Object-oriented class system
- **leaflet.extras**: Additional tools for leaflet
- **leaflet.extras2**: More tools for leaflet
- **htmltools**: HTML generation utilities
- **jsonlite**: JSON handling
- **RColorBrewer**: Color palettes
- **viridisLite**: Perceptually uniform color palettes

## Contributing

Contributions are welcome! Please see our [contribution guidelines](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- The [leaflet](https://rstudio.github.io/leaflet/) project for the core mapping functionality
- [NASA GIBS](https://wiki.earthdata.nasa.gov/display/GIBS) for satellite imagery services
- All contributors and package maintainers whose work makes this possible