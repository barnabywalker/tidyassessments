#' A rule-based model.
#'
#' Provides a [stats::glm] type wrapper around user-defined function specifying
#' rules for a classification function.
#'
#' @param formula an object of class [stats::formula], should specify the target
#'  and all predictors used in the rule function as a linear combination,
#'  e.g. target ~ rule1 + rule2.
#' @param data a dataframe containing the variables and target of the rule function.
#' @param rules a function implementing the rules-based classification.
#'
#' @return an object class similar to "glm" that can be used with a 'predict' method.
#'
#' @examples
#'
#' d <- data.frame(
#'   y=c("apple", "apple", "not apple", "not apple"),
#'   shape=c("round", "round", "square", "round"),
#'   colour=c("green", "red", "green", "purple")
#' )
#'
#' f <- function(shape, colour) {
#'   ifelse(shape == "round" & colour %in% c("green", "red"), "apple", "not apple")
#' }
#'
#' apple_classifier <- rule_based_assessment(y ~ shape + colour, d, f)
#'
#' predict(apple_classifier, newdata=data.frame(shape="round", colour="indigo"))
#'
#' @export
#'
rule_based_assessment <- function(formula, data, rules) {
  call <- match.call()
  if (missing(data)) environment(formula)
  mf <- match.call(expand.dots=FALSE)
  m <- match(c("formula", "data"), names(mf), 0L)
  mf <- mf[c(1L, m)]
  mf$drop.unused.levels <- TRUE
  mf[[1L]] <- quote(stats::model.frame)
  mf <- eval(mf, parent.frame())

  mt <- attr(mf, "terms")

  rule_names <- attr(mt, "term.labels")

  if (length(rule_names) != length(formals(rules))) {
    rlang::abort("Number of terms in formula must match number of arguments to rule function.")
  }

  structure(
    list(
      call=call,
      formula=formula,
      terms=rule_names,
      data=data,
      rules=rules,
      method=as.character(call$rules)
    ),
    class=c("rule_assessment")
  )
}

#' @export
print.rule_assessment <- function(x, ...) {
  cat("\nCall: ", paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n\n", sep = "")
  cat("Rule-set name: ", x$method, "\n", sep="")
  cat("Using rules based on: ", paste(x$terms, collapse=", "), "\n", sep="")
  invisible(x)
}

#' @export
predict.rule_assessment <- function(object, newdata=NULL, ...) {
  if (missing(newdata)) {
    newdata <- object$data
  }

  args <- lapply(object$terms, function(x) dplyr::pull(newdata, x))
  do.call(object$rules, args)
}
