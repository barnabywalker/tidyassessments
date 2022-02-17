#' @importFrom parsnip set_new_model
#' @importFrom stats predict
#'

.onLoad <- function(libname, pkgname) {
  make_rule_based()
}
