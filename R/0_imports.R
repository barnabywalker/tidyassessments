#' @importFrom parsnip set_new_model
#' @importFrom stats predict
#' @importFrom rlang eval_tidy
#' @importFrom dplyr enquo expr

utils::globalVariables(c("x", "y"))

.onLoad <- function(libname, pkgname) {
  make_rule_based()
  make_iucnn()
}
