% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ZIPLNnetwork.R
\name{ZIPLNnetwork}
\alias{ZIPLNnetwork}
\title{Zero Inflated Sparse Poisson lognormal model for network inference}
\usage{
ZIPLNnetwork(
  formula,
  data,
  subset,
  weights,
  zi = c("single", "row", "col"),
  penalties = NULL,
  control = ZIPLNnetwork_param()
)
}
\arguments{
\item{formula}{an object of class "formula": a symbolic description of the model to be fitted.}

\item{data}{an optional data frame, list or environment (or object coercible by as.data.frame to a data frame) containing the variables in the model. If not found in data, the variables are taken from environment(formula), typically the environment from which lm is called.}

\item{subset}{an optional vector specifying a subset of observations to be used in the fitting process.}

\item{weights}{an optional vector of observation weights to be used in the fitting process.}

\item{zi}{a character describing the model used for zero inflation, either of
\itemize{
\item "single" (default, one parameter shared by all counts)
\item "col" (one parameter per variable / feature)
\item "row" (one parameter per sample / individual).
If covariates are specified in the formula RHS (see details) this parameter is ignored.
}}

\item{penalties}{an optional vector of positive real number controlling the level of sparsity of the underlying network. if NULL (the default), will be set internally. See \code{PLNnetwork_param()} for additional tuning of the penalty.}

\item{control}{a list-like structure for controlling the optimization, with default generated by \code{\link[=ZIPLNnetwork_param]{ZIPLNnetwork_param()}}. See the associated documentation
for details.}
}
\value{
an R6 object with class \code{\link{ZIPLNnetworkfamily}}
}
\description{
Perform sparse inverse covariance estimation for the Zero Inflated Poisson lognormal model
using a variational algorithm. Iterate over a range of logarithmically spaced sparsity parameter values.
Use the (g)lm syntax to specify the model (including covariates and offsets).
}
\details{
Covariates for the Zero-Inflation parameter (using a logistic regression model) can be specified in the formula RHS using the pipe
(\verb{~ PLN effect | ZI effect}) to separate covariates for the PLN part of the model from those for the Zero-Inflation part.
Note that different covariates can be used for each part.
}
\examples{
data(trichoptera)
trichoptera <- prepare_data(trichoptera$Abundance, trichoptera$Covariate)
myZIPLNs <- ZIPLNnetwork(Abundance ~ 1, data = trichoptera, zi = "single")
}
\seealso{
The classes \code{\link{ZIPLNfit}} and \code{\link{ZIPLNnetworkfamily}}
}
