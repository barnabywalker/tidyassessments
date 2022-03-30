
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyassessments

<!-- badges: start -->

[![R-CMD-check](https://github.com/barnabywalker/tidyassessments/workflows/R-CMD-check/badge.svg)](https://github.com/barnabywalker/tidyassessments/actions)
[![DOI](https://zenodo.org/badge/460609238.svg)](https://zenodo.org/badge/latestdoi/460609238)
<!-- badges: end -->

This is a package to make some models used for occurrence-based
automated extinction risk assessments work with the
[`tidymodels`](https://www.tidymodels.org/) workflow.

This package was developed to help the analysis for a paper developing
[guidelines for automated conservation
assessments](https://github.com/barnabywalker/guidelines-for-automated-assessments).
To add new models to `tidymodels`, it’s best to package them up so they
work in parallel across platforms. This is a package to make some models
used for occurrence-based automated extinction risk assessments work
with the `tidymodels` workflow.

So far, the models implemented produce binary classifications of species
as “threatened” or “not threatened”.

## Installation

You can install the development version of tidyassessments like so:

``` r
remotes::install_github("barnabywalker/tidyassessments")
```

## Example

You can set up a `tidymodels` model specification like this:

``` r
library(tidyassessments)

spec <- rule_based(engine="eoo")
```

## How is extinction risk assessed?

Species can be put at risk of extinction from all manner of things based
on intrinsic properties of the species, pressure from human activity,
threats from the natural world, or any number of interactions between
these things. Having a way to assess and compare which species are most
at risk helps to focus policy and funding to help slow or prevent
biodiversity loss.

The most widely recognised system for assessing extinction risk is the
[IUCN Red List of Threatened Species](https://www.iucnredlist.org/).
Adding species to the Red List involves gathering all available data
about a species and the threats it faces. An assessor will then [apply
one or more quantitative criteria to this data and determine which Red
List category](iucnredlist.org/resources/summary-sheet) the species
falls under. The Red List categories are Least Concern (LC), Near
Threatened (NT), Vulnerable (V), Endangered (EN), Critically Endangered
(CR), Extinct in the Wild (EW), and Extinct (EX). When there is not
enough data to sort a species into one of these categories, it is
designated as Data Deficient (DD).

## Why automate assessments?

Gathering all this data for a single species takes a lot of time. On top
of this, each assessment needs to be reviewed by experts before it is
published. Ideally, all species should be assessed for the Red List, and
these assessments should be periodically updated. However, only a
fraction of some groups has been assessed. For example, \~15% of the
c. 400,000 plant species are documented on the Red List.

Researchers have proposed many different approaches and tools to
automate the assessment process. These focus on a few different goals
and use a broad range of data as inputs, but all are intended to speed
up or reduce the burden of carrying out assessments. [Cavazali et
al. (2021)](https://www.sciencedirect.com/science/article/pii/S0169534721003372)
have a good review of automated assessment methods and how the gap
between researching and using these methods can be closed.

That review splits automated assessment methods into two distinct
categories: criteria-explicit and category-predictive. Criteria-explicit
methods focus on automating the calculation of parameters that can be
used to directly apply one or more of the IUCN Red List criteria.
Category-predictive methods try to predict the Red List category of a
species from correlates of extinction risk. While criteria-explicit
methods apply the Red List criteria as classification rules,
category-predictive methods often use statistical or machine learning to
learn classification rules.

## How can `tidymodels` help?

Despite these differences, developing or trying out an AA method
generally follows a similar set of steps:

1.  Get a list of accepted species together for a particular taxonomic
    group or area of interest (e.g. all species in the plant genus
    *Myrcia*).
2.  Find all existing assessments for your species list.
3.  Gather together all relevant data (e.g. all occurrence records for
    your species from GBIF).
4.  Carry out any pre-processing/cleaning on your input data
    (e.g. remove occurrence records with dubious coordinates).
5.  Calculate the parameters/predictors necessary for your chosen AA
    method.
6.  Evaluate the performance of your chosen method on species that have
    already been assessed. This step also involves hyperparameter tuning
    (if needed) and training the model for machine-learning approaches.
7.  Use your chosen method to predict the status of unassessed species.

[`tidymodels`](https://www.tidymodels.org/) can help with steps 6 and 7:
tuning, training, evaluating, and applying AA methods. It does this by
providing a consistent interface to different machine learning and
statistical models. We think that reduces the barrier to using these
models while ensuring good practice. We’ve made this package to provide
interfaces to some criteria-explicit and category-predictive automated
assessment methods.

Our paper “Evidence-based guidelines for automated conservation
assessments of plant species” might be interesting if you’d like more
information about automated assessment methods.

We’ve added a handful of tutorials if you’d like more information about
using `tidymodels` for automated assessments.
