# geodlmap Developer Guide

This guide provides information for developers who want to maintain, extend, or contribute to the geodlmap framework.

## Project Structure

geodlmap follows a modular design pattern with functionality divided into logical components:

```
geodlmap/
├── R/
│   ├── core/           # Core functionality and class definitions
│   ├── layers/         # Layer management functions
│   ├── tools/          # Interactive tools
│   ├── widgets/        # Special purpose widgets 
│   ├── analysis/       # Analysis functions
│   └── exports/        # Export functionality
├── inst/               # Installed files
├── man/                # Documentation
├── tests/              # Unit tests
└── vignettes/          # User guides
```

## Design Philosophy

geodlmap follows these design principles:

1. **Modularity**: Each component has a single responsibility
2. **Method chaining**: Functions return `self` to enable chaining
3. **Consistent interfaces**: Similar functions have similar parameter patterns
4. **Comprehensive documentation**: All functions have complete documentation
5. **User-friendly errors**: Clear error messages help troubleshoot issues

## Adding New Functionality

### Adding a Method to the geodlmap Class

To add a new method to the geodlmap class, create a new file in the appropriate subdirectory and add the method using `$set()`:

```r
# R/layers/new_layer_type.R
#' @title Add new layer type to geodlmap
#' @description Description of the new layer type
#' @param parameter_1 Description of parameter 1
#' @param parameter_2 Description of parameter 2
#' @return geodlmap object (invisibly)
#' @export
geodlmap$set("public", "addNewLayerType", function(parameter_1, parameter_2) {
  # Implementation
  
  # Store reference
  self$datasets[[name]] <- list(
    # Layer properties
    type = "new_layer_type"
  )
  
  message("Added new layer type")
  return(invisible(self))
})
```

### Adding a Utility Function

For standalone utility functions:

```r
# R/analysis/new_analysis.R
#' @title New analysis function
#' @description Description of the analysis function
#' @param data Data to analyze
#' @return Analysis result
#' @export
new_analysis_function <- function(data) {
  # Implementation
  result <- # Analysis logic
  return(result)
}
```

### Updating the Package

Remember to add any new files to the package loading sequence in `R/zzz.R`:

```r
# R/zzz.R
.onLoad <- function(libname, pkgname) {
  # Existing loading code
  
  # Add your new file
  source(system.file("R", "your/new/file.R", package = "geodlmap"))
}
```

## Testing New Functionality

Create tests for new functionality in the `tests/testthat/` directory:

```r
# tests/testthat/test-new-feature.R
context("New Feature")

test_that("new feature works correctly", {
  # Setup
  myMap <- geodlmap$new()
  
  # Test the feature
  result <- myMap$newFeature(parameter = value)
  
  # Check expectations
  expect_true(some_condition)
  expect_equal(result_value, expected_value)
})
```

## Documentation

Document all public functions and methods using roxygen2 format:

```r
#' @title Function title
#' @description Detailed description of the function
#' @param parameter Description of parameter
#' @return Description of return value
#' @examples
#' \dontrun{
#' example_code()
#' }
#' @export
```

## Code Style

Follow these style guidelines:

1. Use 2-space indentation
2. Use snake_case for variable and function names
3. Use CamelCase for class names
4. Keep lines under 80 characters when possible
5. Add meaningful comments for complex logic
6. Use consistent naming patterns for similar functions

## Common Extension Points

### Adding a New Basemap Provider

1. Update the `providers_list` in `addBasemap()` method
2. Add the provider URL pattern

### Adding a New Data Source

1. Create a new method in the `layers/` directory
2. Implement data loading and visualization logic
3. Store the dataset reference in `self$datasets`

### Adding a New Visualization Type

1. Create a new method in the `widgets/` directory
2. Implement the visualization logic
3. Return an HTML widget or leaflet map object

## Deployment

### Building the Package

```r
# Generate documentation
devtools::document()

# Check the package
devtools::check()

# Build the package
devtools::build()
```

### Releasing a New Version

1. Update the version number in `DESCRIPTION`
2. Update the `NEWS.md` file with changes
3. Commit changes to version control
4. Create a release tag
5. Build and submit to CRAN or your repository

## Troubleshooting

### Common Issues

1. **Missing dependencies**: Ensure all required packages are specified in `DESCRIPTION`
2. **JavaScript errors**: Check browser console when debugging HTML widgets
3. **Loading errors**: Verify file paths in `zzz.R` source statements
4. **Namespace issues**: Make sure to export all public functions

### Debugging Tips

1. Use `browser()` statement to enter interactive debugging
2. Log intermediate states with `message()` or `cat()`
3. For HTML widgets, add `console.log()` statements in JavaScript
4. Check the structure of objects with `str()`

## Performance Considerations

1. Avoid large raster operations in the main thread
2. Use `leaflet::addRasterImage()` with `project = FALSE` for large rasters
3. Consider tiled services for very large datasets
4. Limit the number of vector features for smooth interactivity
5. Use appropriate simplification for complex geometries

## Future Development Directions

Potential areas for enhancement:

1. Integration with cloud storage services
2. Server-side processing for large datasets
3. Enhanced data analysis tools
4. Mobile-friendly responsive layouts
5. 3D visualization capabilities
6. Time series analysis tools
7. Advanced geoprocessing functions

## Contributing

See our [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on making contributions to the geodlmap project.