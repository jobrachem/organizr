
# organizr

<!-- badges: start -->
[![R-CMD-check](https://github.com/jobrachem/organizr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jobrachem/organizr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Organizr provides code-shortcuts to quickly create R scripts, as well as 
minimal Quarto and Rmarkdown documents with a consistent naming scheme.

## Installation

You can install the development version of organizr like so:

``` r
# install.packages("devtools") # if you do not have devtools installed
devtools::install_github("tidyverse/dplyr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(organizr)
## basic example code
```

## Options

- `organizr.prefix_delim`
- `organizr.prefix_by` can be "count" or "date"
- `organizr.prefix_date_format` 
- `organizr.r.init_with_date`
- `organizr.r.date_format`

