#' Rule based classification
#'
#' `rule_based()` defines a model that uses fixed rules to classify an input.
#'
#' As the model uses fixed rules, fitting it just creates a model object.
#' Different sets of rules are implemented as model *engines*.
#'
#' Information about the class of model fit can be found in [tidyassessments::rule_based_assessment].
#' The engine-specific pages for the different rule sets can be found in:
#'   * [tidyassessments::eoo_threshold] (default)
#'   * [tidyassessments::conr_thresholds]
#'
#' More information on how parsnip is used for modeling is at https://www.tidymodels.org/.
#'
#' @param mode A single character string for the prediction outcome mode.
#'   Only "classification" is allowed.
#' @param engine A single character string specifying the engine to use.
#'
#' @examples
#' parsnip::show_engines("rule_based")
#'
#' rule_based(mode="classification", engine="conr")
#'
#' @export
#'
rule_based <- function(mode="classification", engine="eoo") {
  if (mode != "classification") {
    rlang::abort("`mode` should be 'classification'")
  }

  parsnip::new_model_spec(
    "rule_based",
    args=NULL,
    eng_args=NULL,
    mode=mode,
    method=NULL,
    engine=engine
  )
}

#' Classify species as threatened using [ConR](https://github.com/gdauby/conr) rules.
#'
#' `IUCN.eval` (from ConR) approximates a full classification based on criterion
#' B, using the EOO, AOO, and an estimate of the number of locations
#' for a species. This function implements that classification, then
#' makes the prediction coarser to "threatened" or "not threatened".
#'
#' @param eoo The EOO in km^2.
#' @param aoo The AOO in km^2.
#' @param locations The number of threat-defined locations estimated by ConR.
#'
#' @return classification of whether a species is threatened or not.
#'
conr_thresholds <- function(eoo, aoo, locations) {
  rank_eoo <- dplyr::case_when(
    is.na(eoo) ~ NA_real_,
    eoo < 100 ~ 1,
    eoo < 5000 ~ 2,
    eoo < 20000 ~ 3,
    TRUE ~ 4
  )

  rank_aoo <- dplyr::case_when(
    aoo < 10 ~ 1,
    aoo < 500 ~ 2,
    aoo < 2000 ~ 3,
    TRUE ~ 4
  )

  rank_loc <- dplyr::case_when(
    locations == 1 ~ 1,
    locations <= 5 ~ 2,
    locations <= 10 ~ 3,
    TRUE ~ 4
  )

  rank_b1a <- pmax(rank_eoo, rank_loc)
  rank_b2a <- pmax(rank_aoo, rank_loc)

  rank_b <- pmin(rank_b1a, rank_b2a, na.rm=TRUE)

  dplyr::case_when(
    rank_b == 3 & locations < 11 ~ "threatened",
    rank_b < 3 ~ "threatened",
    TRUE ~ "not threatened"
  )
}

#' Wrapper for tidymodels interface for ConR thresholds.
#'
#' @param formula An object of class [stats::formula] specifying the target column
#'   in relation to the EOO, AOO, and locations column, e.g. y ~ eoo + aoo + locs.
#' @param data A dataframe with the target, EOO, AOO, and number of locations.
#'
#' @export
#'
conr_rules <- function(formula, data) rule_based_assessment(formula, data, rules=conr_thresholds)

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

