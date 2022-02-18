#' Parameter objects for occurrence-based automated conservation assessment models.
#'
#' `layers()` describes a specification of the layers in neural network as
#' a string with the number of hidden units in each layer separated by an underscore,
#' e.g "40_20" specifies a two-layer network with 40 units in the first layer and 20
#' in the second.
#'
#' @param values The possible layer specifications to use.
#'
#' @return A function of class 'qual_param' and 'param'.
#'
#' @examples
#' layers(c("10", "40_20", "50_30_10"))
#'
#' @export
#'
layers <- function(values=values_layers) {
  dials::new_qual_param(
    type="character",
    values=values,
    label=c(layers="Neural network layer specification"),
    default="30",
    finalize=NULL
  )
}

# this is very hacky but not sure how to get around it
#' @rdname layers
#' @export
values_layers <- c("10", "20", "30", "40", "50", "30_10", "40_20", "50_30_10")
