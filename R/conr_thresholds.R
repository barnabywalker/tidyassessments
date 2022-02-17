#' Classify species as threatened using [ConR](https://github.com/gdauby/conr) rules.
#'
#' [ConR::IUCN.eval] approximates a full classification based on criterion
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
