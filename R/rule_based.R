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
#'   Only "classification is allowed.
#' @param engine A single character string specifying the rule-set engine to use.
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
