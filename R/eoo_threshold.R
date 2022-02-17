#' Classify species as threatened or not based on the IUCN threshold
#' on EOO (criterion B1).
#'
#' @param eoo The EOO in km
#'
#' @return classification of whether a species is threatened or not.
#'
#' @export
eoo_threshold <- function(eoo) {
  ifelse(eoo <= 20000, "threatened", "not threatened")
}

#' Wrapper for tidymodels interface for EOO threshold rule.
#'
#' @param formula An object of class [stats::formula] specifying the target column
#'   in relation to the EOO column, e.g. y ~ eoo.
#' @param data A dataframe with the target and EOO.
#'
#' @export
#'
eoo_rules <- function(formula, data) rule_based_assessment(formula, data, rules=eoo_threshold)
