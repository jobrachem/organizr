
# Organizr: Tidy up your projects for good!

<!-- badges: start -->
[![R-CMD-check](https://github.com/jobrachem/organizr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jobrachem/organizr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Organizr provides opinionated code-shortcuts to quickly create R scripts, as well as 
minimal Quarto and Rmarkdown documents with a consistent naming scheme.

Organizr offers a count-based prefix...

```
R/
  001_first-script.R
  002_another-script.R
  003_and-so-on.R
```

... and a date-based prefix.

```
R/
  2022-09-24_first-script.R
  2022-09-26_another-script.R
  2022-09-26_and-so-on.R
```

## Installation

You can install the development version of organizr like so:

``` r
# install.packages("devtools") # if you do not have devtools installed
devtools::install_github("jobrachem/organizr")
```

## Setup

The best user experience arises, if you load `organizr` in the `.Rprofile` of
your current project. To do so, you can use the following line to open your
project's .Rprofile:

```r
# install.packages("usethis")
usethis::edit_r_profile(scope = "project")
```

Then place the following line inside the .Rprofile:

``` r
library(organizr)
```

Now, you will always be able to create consistently named new R scripts via
quick and simple function calls like

```r
r("my-script")
```

If this is the first R file in your project, this function call will create
the file `001_my-script.R` in the directory `project_path/R`.

## Some details

Organizr offers the three following function:

- `r()` creates an R script with a timestamp in `project_path/R`.
- `qmd()` creates a minimal Quarto document in `project_path/qmd`.
- `rmd()` creates a minimal Quarto document in `project_path/rmd`.

Organizr is an opinionated packaged. It may very well be that it does not fit
your personal workflow, and that's ok. 

## Options

You can set some global options via 

```r
options("option_name" = "option_value")
```

If you want to use options, it often makes sense to also place them directly in
the .Rprofile file.

The available options are:

- `organizr.prefix_delim`: Which character to insert as a separator between the prefix and the actual file name. The default is `"_"`
- `organizr.prefix_by`: Can be used to override the function default of `"count"`. Can be `"count"` or `"date"`.
- `organizr.prefix_date_format`: Date format for date prefixes. Can be any format string accepted by `strftime`. Default is `"%Y-%m-%d"`.
- `organizr.r.init_with_date`: Can be set to `FALSE` to turn off the inclusion of the timestamp comment at the top of R scripts.
- `organizr.r.date_format`: Date format for R script timestamp comment. Can be any format string accepted by `strftime`. Default is `"%Y-%m-%d %H:%M"`.

