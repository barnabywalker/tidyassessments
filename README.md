
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyassessments

<!-- badges: start -->

[![R-CMD-check](https://github.com/barnabywalker/tidyassessments/workflows/R-CMD-check/badge.svg)](https://github.com/barnabywalker/tidyassessments/actions)
<!-- badges: end -->

This is a package to make some models used for occurrence-based
automated extinction risk assessments work with the tidymodels workflow.

This package was developed to help the analysis for a paper developing
[guidelines for automated conservation
assessments](https://github.com/barnabywalker/guidelines-for-automated-assessments).
To add new models to tidymodels, it’s best to package them up so they
work in parallel across platforms.This is a package to make some models
used for occurrence-based automated extinction risk assessments work
with the tidymodels workflow.

This package was developed to help the analysis for a paper developing
[guidelines for automated conservation
assessments](https://github.com/barnabywalker/guidelines-for-automated-assessments).

So far, the models implemented produce binary classifications of species
as “threatened” or “not threatened”.

-   Rule-based models, using fixed thresholds on computed metrics:
    -   IUCN threshold - a single threshold on the Extent of Occurrence
        (EOO) of a species.
    -   ConR - thresholds on EOO, area of occupancy (AOO), and number of
        locations intended to approximate an IUCN Red List criterion B
        assessment.

## Installation

You can install the development version of tidyassessments like so:

``` r
remotes::install_github("barnabywalker/tidyassessments")
```

## Example

You can set up a tidymodels model specification like this:

``` r
library(tidyassessments)

spec <- rule_based(engine="eoo")
```
