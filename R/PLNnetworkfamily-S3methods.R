## =========================================================================================
##
## PUBLIC S3 METHODS FOR PLNnetworkfamily + OTHER FUNCTIONS
##
## =========================================================================================


## Auxiliary functions to check the given class of an objet
isNetworkfamily <- function(Robject) {inherits(Robject, "Networkfamily")}

#' Display various outputs (goodness-of-fit criteria, robustness, diagnostic) associated with a collection of network fits (either [`PLNnetworkfamily`] or [`ZIPLNnetworkfamily`])
#'
#' @inheritParams plot.PLNfamily
#' @inherit plot.PLNfamily return details
#'
#' @param x an R6 object with class [`PLNnetworkfamily`] or [`ZIPLNnetworkfamily`]
#' @param type a character, either "criteria", "stability" or "diagnostic" for the type of plot.
#' @param criteria Vector of criteria to plot, to be selected among "loglik" (log-likelihood),
#' "BIC", "ICL", "R_squared", "EBIC" and "pen_loglik" (penalized log-likelihood).
#' Default is  c("loglik", "pen_loglik", "BIC", "EBIC"). Only used when `type = "criteria"`.
#' @param log.x logical: should the x-axis be represented in log-scale? Default is `TRUE`.
#' @param stability scalar: the targeted level of stability in stability plot. Default is .9.
#'
#' @examples
#' data(trichoptera)
#' trichoptera <- prepare_data(trichoptera$Abundance, trichoptera$Covariate)
#' fits <- PLNnetwork(Abundance ~ 1, data = trichoptera)
#' \dontrun{
#' plot(fits)
#' }
#' @return Produces either a diagnostic plot (with `type = 'diagnostic'`), a stability plot
#' (with `type = 'stability'`) or the evolution of the criteria of the different models considered
#' (with `type = 'criteria'`, the default).
#' @export
plot.Networkfamily <- function(x,
           type     = c("criteria", "stability", "diagnostic"),
           criteria = c("loglik", "pen_loglik", "BIC", "EBIC"),
           reverse = FALSE,
           log.x    = TRUE,
           stability = 0.9, ...) {
  stopifnot(isNetworkfamily(x))
  type <- match.arg(type)
  if (type == "criteria")
    p <- x$plot(criteria, reverse)
  if (type == "stability")
    p <- x$plot_stars(stability, log.x)
  if (type == "diagnostic")
    p <- x$plot_objective()

  p
}

#' @describeIn plot.Networkfamily Display various outputs associated with a collection of network fits
#' @export
plot.PLNnetworkfamily <- plot.Networkfamily

#' @describeIn plot.Networkfamily Display various outputs associated with a collection of network fits
#' @export
plot.ZIPLNnetworkfamily <- plot.Networkfamily

#' @describeIn getModel Model extraction for [`PLNnetworkfamily`] or [`ZIPLNnetworkfamily`]
#' @export
getModel.Networkfamily <- function(Robject, var, index = NULL) {
  stopifnot(isNetworkfamily(Robject))
  Robject$getModel(var, index)
}

#' @describeIn getModel Model extraction for [`PLNnetworkfamily`]
#' @export
getModel.PLNnetworkfamily <- getModel.Networkfamily

#' @describeIn getModel Model extraction for [`ZIPLNnetworkfamily`]
#' @export
getModel.ZIPLNnetworkfamily <- getModel.Networkfamily

#' @describeIn getBestModel Model extraction for [`PLNnetworkfamily`] or [`ZIPLNnetworkfamily`]
#' @export
getBestModel.Networkfamily <- function(Robject, crit = c("BIC", "EBIC", "StARS"), ...) {
  stopifnot(isNetworkfamily(Robject))
  stability <- list(...)[["stability"]]
  if (is.null(stability)) stability <- 0.9
  Robject$getBestModel(match.arg(crit), stability)
}

#' @describeIn getBestModel Model extraction for [`PLNnetworkfamily`]
#' @export
getBestModel.PLNnetworkfamily <- getBestModel.Networkfamily

#' @describeIn getBestModel Model extraction for [`ZIPLNnetworkfamily`]
#' @export
getBestModel.ZIPLNnetworkfamily <- getBestModel.Networkfamily

#' Extract the regularization path of a PLNnetwork fit
#'
#' @name coefficient_path
#' @param Robject an object with class [`Networkfamily`], i.e. an output from [PLNnetwork()]
#' @param precision a logical, should the coefficients of the precision matrix Omega or the covariance matrix Sigma be sent back. Default is `TRUE`.
#' @param corr a logical, should the correlation (partial in case  `precision = TRUE`) be sent back. Default is `TRUE`.
#'
#' @return  Sends back a tibble/data.frame.
#' @examples
#' data(trichoptera)
#' trichoptera <- prepare_data(trichoptera$Abundance, trichoptera$Covariate)
#' fits <- PLNnetwork(Abundance ~ 1, data = trichoptera)
#' head(coefficient_path(fits))
#' @export
coefficient_path <- function(Robject, precision = TRUE, corr = TRUE) {
  stopifnot(isNetworkfamily(Robject))
  Robject$coefficient_path(precision, corr)
}

#' Compute the stability path by stability selection
#'
#' @name stability_selection
#'
#' @description This function computes the StARS stability criteria over a path of penalties. If a path has already been computed, the functions stops with a message unless `force = TRUE` has been specified.
#'
#' @param Robject an object with class [`PLNnetworkfamily`] or [`ZIPLNnetworkfamily`], i.e. an output from [PLNnetwork()] or [ZIPLNnetwork()]
#' @param subsamples a list of vectors describing the subsamples. The number of vectors (or list length) determines th number of subsamples used in the stability selection. Automatically set to 20 subsamples with size `10*sqrt(n)` if `n >= 144` and `0.8*n` otherwise following Liu et al. (2010) recommendations.
#' @param control a list controlling the main optimization process in each call to [PLNnetwork()] or [ZIPLNnetwork()]. See [PLN_param()] or [ZIPLN_param()] for details.
#' @param force force computation of the stability path, even if a previous one has been detected.
#'
#' @return the list of subsamples. The estimated probabilities of selection of the edges are stored in the fields `stability_path` of the initial Robject with class [`Networkfamily`]
#' @examples
#' data(trichoptera)
#' trichoptera <- prepare_data(trichoptera$Abundance, trichoptera$Covariate)
#' fits <- PLNnetwork(Abundance ~ 1, data = trichoptera)
#' \dontrun{
#' n <- nrow(trichoptera)
#' subs <- replicate(10, sample.int(n, size = n/2), simplify = FALSE)
#' stability_selection(nets, subsamples = subs)
#' }
#' @export
stability_selection <- function(Robject, subsamples = NULL, control = PLNnetwork_param(), force = FALSE) {
  stopifnot(isNetworkfamily(Robject))
  if (inherits(Robject, "ZIPLNnetworkfamily")) control <- ZIPLNnetwork_param()
  if (force || anyNA(Robject$stability)) {
    Robject$stability_selection(subsamples, control)
  } else {
    message("Previous stability selection detected. Use \"force = TRUE\" to recompute it.")
  }
}

#' Extract edge selection frequency in bootstrap subsamples
#'
#' @description Extracts edge selection frequency in networks reconstructed from bootstrap subsamples
#' during the stars stability selection procedure, as either a matrix or a named vector. In the latter
#' case, edge names follow igraph naming convention.
#'
#' @inheritParams getModel
#' @inheritParams getBestModel
#' @param Robject an object with class [`PLNnetworkfamily`], i.e. an output from [PLNnetwork()]
#' @param penalty penalty used for the bootstrap subsamples
#' @param format output format. Either a matrix (default) or a named vector.
#' @param tol tolerance for rounding error when comparing penalties.
#'
#' @return Either a matrix or named vector of edge-wise probabilities. In the latter case, edge names follow igraph convention.
#' @export
#' @examples
#' data(trichoptera)
#' trichoptera <- prepare_data(trichoptera$Abundance, trichoptera$Covariate)
#' nets <- PLNnetwork(Abundance ~ 1 + offset(log(Offset)), data = trichoptera)
#' \dontrun{
#' stability_selection(nets)
#' probs <- extract_probs(nets, crit = "StARS", format = "vector")
#' probs
#' }
#'
#' \dontrun{
#' ## Add edge attributes to graph using igraph
#' net_stars <- getBestModel(nets, "StARS")
#' g <- plot(net_stars, type = "partial_cor", plot=F)
#' library(igraph)
#' E(g)$prob <- probs[as_ids(E(g))]
#' g
#' }
#'
#' @importFrom stats setNames
#'
extract_probs <- function(Robject, penalty = NULL, index = NULL,
                          crit = c("StARS", "BIC", "EBIC"),
                          format = c("matrix", "vector"),
                          tol = 1e-5) {
  stopifnot(isNetworkfamily(Robject))
  ## Check if stability selection has been performed
  stab_path <- Robject$stability_path
  if (is.null(stab_path)) {
    stop("Please perform stability selection using stability_selection(Robject) first")
  }
  ## Select model from penalty and/or index
  if (!is.null(penalty) || !is.null(index)) {
    model <- getModel(Robject, penalty, index)
  } else {
    ## Select index from criteria
    model <- getBestModel(Robject, match.arg(crit))
  }
  pen <- model$penalty
  ## extract relevant portion from the stability path
  stab_path <- dplyr::filter(stab_path, abs(stab_path$Penalty - pen) < tol)
  format <- match.arg(format)
  if (format == "vector") {
    return(setNames(stab_path$Prob, stab_path$Edge))
  }
  if (format == "matrix") {
    ## initialize matrix with correct names and dimensions
    mat <- model$model_par$Omega
    mat[] <- 0
    ## Fill and symmetrize
    edge_array_index <- stab_path %>% dplyr::select('Node1', 'Node2') %>% as.matrix()
    mat[edge_array_index] <- stab_path$Prob
    mat <- mat + t(mat)
    mat
  }
}
