
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FishPlot

<!-- badges: start -->
<!-- badges: end -->

The goal of FishPlot is to plot the fish caught on the DFO Maritimes
Ecosystem Survey

Currently supported Species include: 23 Redfish, 11 Haddock, 10 Cod, 14
Silver hake, 16 Pollock, 30 Halibut, 220 Dogfish, 40 Plaice, 42
Yellowtail, 200 Barndoor skate

## Installation

You can install the development version of FishPlot from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("BradHubley/FishPlot")

#or

devtools::install_github("BradHubley/FishPlot")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(FishPlot)

## basic example code

RED_data.24<-subset(rv_data,YEAR==2024&SPEC==23 )
fishPlot(RED_data.24, Species="Redfish",lab=2024,ladj=0.001,jadj=0.2,nadj=0.01,lscale=30 )
#> Linking to GEOS 3.13.0, GDAL 3.10.1, PROJ 9.5.1; sf_use_s2() is TRUE
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
#> ✔ purrr     1.0.4     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
#> Warning: Removed 2 rows containing missing values or values outside the scale range
#> (`geom_image()`).
```
