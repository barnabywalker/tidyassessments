# excluded from code coverage as this is added to parsnip database on load

# nocov
make_iucnn <- function() {
  parsnip::set_new_model("iucnn")
  parsnip::set_model_mode(model="iucnn", mode="classification")
  parsnip::set_model_engine("iucnn", mode="classification", eng="keras")
  parsnip::set_dependency("iucnn", eng="keras", pkg="tidyassessments")

  parsnip::set_model_arg(
    model="iucnn",
    eng="keras",
    parsnip="epochs",
    original="epochs",
    func=list(pkg="dials", fun="epochs"),
    has_submodel=FALSE
  )

  parsnip::set_model_arg(
    model="iucnn",
    eng="keras",
    parsnip="layers",
    original="layers",
    func=list(fun="layers"),
    has_submodel=FALSE
  )

  parsnip::set_model_arg(
    model="iucnn",
    eng="keras",
    parsnip="dropout",
    original="dropout",
    func=list(fun="dropout", pkg="dials"),
    has_submodel=FALSE
  )

  parsnip::set_fit(
    model="iucnn",
    eng="keras",
    mode="classification",
    value=list(
      interface="matrix",
      protect=c("x", "y"),
      func=c(fun="iucnn_model"),
      defaults=list()
    )
  )

  parsnip::set_encoding(
    model="iucnn",
    eng="keras",
    mode="classification",
    options=list(
      predictor_indicators="traditional",
      compute_intercept=TRUE,
      remove_intercept=TRUE,
      allow_sparse_x=FALSE
    )
  )


  parsnip::set_pred(
    model="iucnn",
    eng="keras",
    mode="classification",
    type="class",
    value=list(
      pre=NULL,
      post=NULL,
      func=c(fun="keras_predict_classes"),
      args=list(
        object=quote(object),
        x=quote(as.matrix(new_data))
      )
    )
  )

  parsnip::set_pred(
    model = "iucnn",
    eng = "keras",
    mode = "classification",
    type = "prob",
    value = list(
      pre = NULL,
      post = function(x, object) {
        colnames(x) <- object$lvl
        x <- as_tibble(x)
        x
      },
      func = c(fun = "predict"),
      args =
        list(
          object = quote(object$fit),
          x = quote(as.matrix(new_data))
        )
    )
  )

  parsnip::set_pred(
    model = "iucnn",
    eng = "keras",
    mode = "classification",
    type = "raw",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args =
        list(
          object = quote(object$fit),
          x = quote(as.matrix(new_data))
        )
    )
  )
}
