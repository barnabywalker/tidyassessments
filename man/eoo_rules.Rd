% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rule_based.R
\name{eoo_rules}
\alias{eoo_rules}
\title{Wrapper for tidymodels interface for EOO threshold rule.}
\usage{
eoo_rules(formula, data)
}
\arguments{
\item{formula}{An object of class \link[stats:formula]{stats::formula} specifying the target column
in relation to the EOO column, e.g. y ~ eoo.}

\item{data}{A dataframe with the target and EOO.}
}
\description{
Wrapper for tidymodels interface for EOO threshold rule.
}
