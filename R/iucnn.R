#' Neural Network classifier to automate occurrence-based conservation assessments
#'
#' `iucnn()` defines a neural network for predicting the conservation status of
#' species given species-level predictors calculated from occurrence records.
#' This is an implementation of the [IUCNN model](https://doi.org/10.1111/ddi.13450)
#' so it works in the tidymodels framework.
#'
#' Currently only the binary threatened/not threatened classification is implemented.
#'
#' @inheritParams rule_based
#' @param layers A string specification of the hidden units in each layer, e.g. "40_20"
#'   for a two-layer network with a 40-unit layer then a 20-unit layer.
#' @param dropout A number between 0 (inclusive) and 1 denoting the proportion
#'  of model parameters randomly set to zero during model training.
#' @param epochs An integer for the number of training iterations.
#'
#' @examples
#' parsnip::show_engines("iucnn")
#'
#' iucnn(layers="40_20", dropout=0.3, epochs=10)
#'
#' @export
#'
iucnn <- function(mode="classification", engine="keras", layers=NULL, dropout=NULL,
                  epochs=NULL) {
  args <- list(
    layers=enquo(layers),
    dropout=enquo(dropout),
    epochs=enquo(epochs),
    learn_rate=enquo(epochs)
  )

  parsnip::new_model_spec(
    "iucnn",
    args=args,
    eng_args=NULL,
    mode=mode,
    method=NULL,
    engine=engine
  )
}

print.iucnn <- function(x, ...) {
  cat("Neural network assessments specification (", x$mode, ")\n\n", sep="")
  parsnip::model_printer(x, ...)

  if (!is.null(x$method$fit$args)) {
    cat("Model fit template:\n")
    print(parsnip::show_call(x))
  }

  invisible(x)
}


#' Check inputs are in correct format
#' @noRd
check_inputs <- function(x, y) {
  if (!is.matrix(x)) {
    x <- as.matrix(x)
  }

  if (is.character(y)) {
    y <- as.factor(y)
  }

  factor_y <- is.factor(y)

  if (! factor_y) {
    rlang::abort("IUCNN classification only implemented currently")
  }

  y <- parsnip:::class2ind(y)

  list(x=x, y=y)
}

#' Check input and validation data are in the correct format
#' @noRd
check_all_data <- function(x, y, validation_data=NULL) {
  checked <- check_inputs(x, y)

  if (is.data.frame(validation_data)) {
    val_x <- as.matrix(validation_data[, colnames(x)])
    y_col <- colnames(validation_data)[!colnames(validation_data) %in% colnames(x)]

    val_y <- validation_data[[y_col]]
  } else if (is.list(validation_data) & length(validation_data) == 2) {
    val_x <- validation_data[[1]]
    val_y <- validation_data[[2]]
  }

  if (!is.null(validation_data)) {
    validation_data <- check_inputs(val_x, val_y)
  }

  checked$validation_data <- validation_data

  checked
}

#' Interface to a neural network model for automated species conservation assessments via keras
#'
#' `iucnn_model()` builds a sequential `keras` model from a string specification of the units
#' in each layer of the network. Regularisation is by dropout.
#'
#' @param x A dataframe of matrix of predictors
#' @param y A vector (factor or character) of outcome data.
#' @param layers A string specification of the number of hidden units in each layer, e.g. "40_20"
#' @param dropout The proportion of parameters to set to zero.
#' @param epochs An integer for the number of passes through the data.
#' @param validation_data A dataframe of data for validation with columns for
#'  predictiors in `x` and the outcome `y`, or a list of two matrices for the predictors and outcome.
#' @param save_history Logical, whether to save the loss values for each epoch during training.
#' @param ... compilation and fitting arguments to pass to the `keras` model.
#'
#' @return A `keras` model object.
#'
#' @export
#'
iucnn_model <- function(x, y, layers="30", dropout=0, epochs=30, validation_data=NULL, save_history=FALSE, ...) {

  checked_data <- check_all_data(x, y, validation_data)
  x <- checked_data$x
  y <- checked_data$y
  validation_data <- checked_data$validation_data

  model <- keras::keras_model_sequential()

  layers <- as.numeric(stringr::str_split(layers, "_")[[1]])

  for (i in seq_along(layers)) {
    if (i == 1) {
      model %>%
        keras::layer_dense(
          units=layers[i],
          activation="relu",
          input_shape=ncol(x)
        ) %>%
        keras::layer_dropout(dropout)
    } else {
      model %>%
        keras::layer_dense(
          units=layers[i],
          activation="relu"
        ) %>%
        keras::layer_dropout(dropout)
    }
  }

  model %>%
    keras::layer_dense(ncol(y), "softmax")

  arg_values <- parsnip:::parse_keras_args(...)
  compile_call <- expr(keras::compile(object=model))

  if (!any(names(arg_values$compile) == "loss")) {
    compile_call$loss <- "binary_crossentropy"
  }

  if (!any(names(arg_values$compile) == "optimizer")) {
    compile_call$optimizer <- "adam"
  }

  compile_call <- rlang::call_modify(compile_call, !!!arg_values$compile)

  model <- eval_tidy(compile_call)

  fit_call <- expr(keras::fit(object=model))
  fit_call$x <- quote(x)
  fit_call$y <- quote(y)
  fit_call$epoch <- epochs
  fit_call$validation_data <- validation_data

  fit_call <- rlang::call_modify(fit_call, !!!arg_values$fit)

  history <- eval_tidy(fit_call)
  model$y_names <- colnames(y)

  if (save_history) {
    model$history <-
      history$metrics %>%
      as_tibble() %>%
      tibble::rowid_to_column(var="epoch")
  }

  model
}

#' Wrapper for keras class predictions
#'
#' Copied from [https://github.com/tidymodels/parsnip/blob/main/R/mlp.R](`parsnip`)
#' as not exported in the current version on CRAN.
#'
#' @param object A keras model fit
#' @param x A data set.
#' @export
#' @keywords internal
keras_predict_classes <- function(object, x) {
  if (utils::packageVersion("keras") >= package_version("2.6")) {
    preds <- predict(object$fit, x)
    if (tensorflow::tf_version() <= package_version("2.0.0")) {
      # -1 to assign with keras' zero indexing
      index <- apply(preds, 1, which.max) - 1
    } else {
      index <- preds %>% keras::k_argmax() %>% as.integer()
    }
  } else {
    index <- keras::predict_classes(object$fit, x)
  }
  object$lvl[index + 1]
}
