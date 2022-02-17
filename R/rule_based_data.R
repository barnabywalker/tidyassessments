# excluded from code coverage as this is added to parsnip database on load

# nocov
make_rule_based <- function() {
  parsnip::set_new_model("rule_based")
  parsnip::set_model_mode(model="rule_based", mode="classification")
  parsnip::set_model_engine("rule_based", mode="classification", eng="eoo")
  parsnip::set_dependency("rule_based", eng="eoo", pkg="tidyassessments")

  # add IUCN threshold based model
  parsnip::set_fit(
    model="rule_based",
    eng="eoo",
    mode="classification",
    value=list(
      interface="formula",
      protect=c("formula", "data"),
      func=c(fun="eoo_rules", pkg="tidyassessments"),
      defaults=list()
    )
  )

  parsnip::set_encoding(
    model = "rule_based",
    eng = "eoo",
    mode = "classification",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = FALSE,
      remove_intercept = TRUE,
      allow_sparse_x = FALSE
    )
  )

  class_info <-
    list(
      pre=NULL,
      post=NULL,
      func=c(fun="predict"),
      args=list(
        object=quote(object$fit),
        newdata=quote(new_data)
      )
    )

  parsnip::set_pred(
    model = "rule_based",
    eng = "eoo",
    mode = "classification",
    type = "class",
    value = class_info
  )

  # Add ConR based model
  parsnip::set_model_engine(
    "rule_based",
    mode="classification",
    eng="conr"
  )

  parsnip::set_dependency("rule_based", eng="conr", pkg="tidyassessments")

  parsnip::set_fit(
    model="rule_based",
    eng="conr",
    mode="classification",
    value=list(
      interface="formula",
      protect=c("formula", "data"),
      func=c(fun="conr_rules", pkg="tidyassessments"),
      defaults=list()
    )
  )

  parsnip::set_encoding(
    model = "rule_based",
    eng = "conr",
    mode = "classification",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = FALSE,
      remove_intercept = TRUE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "rule_based",
    eng = "conr",
    mode = "classification",
    type = "class",
    value = class_info
  )
}

# nocov end
