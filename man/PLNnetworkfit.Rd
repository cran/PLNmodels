% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PLNnetworkfit-class.R
\name{PLNnetworkfit}
\alias{PLNnetworkfit}
\title{An R6 Class to represent a PLNfit in a sparse inverse covariance framework}
\description{
The function \code{\link[=PLNnetwork]{PLNnetwork()}} produces a collection of models which are instances of object with class \code{\link{PLNnetworkfit}}.
This class comes with a set of methods, some of them being useful for the user:
See the documentation for \code{\link[=plot.PLNnetworkfit]{plot()}} and methods inherited from \code{\link{PLNfit}}.
}
\examples{
\dontrun{
data(trichoptera)
trichoptera <- prepare_data(trichoptera$Abundance, trichoptera$Covariate)
nets <- PLNnetwork(Abundance ~ 1, data = trichoptera)
myPLNnet <- getBestModel(nets)
class(myPLNnet)
print(myPLNnet)
}
}
\seealso{
The function \code{\link[=PLNnetwork]{PLNnetwork()}}, the class \code{\link{PLNnetworkfamily}}
}
\section{Super classes}{
\code{\link[PLNmodels:PLNfit]{PLNmodels::PLNfit}} -> \code{\link[PLNmodels:PLNfit_fixedcov]{PLNmodels::PLNfit_fixedcov}} -> \code{PLNnetworkfit}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{vcov_model}}{character: the model used for the residual covariance}

\item{\code{penalty}}{the global level of sparsity in the current model}

\item{\code{penalty_weights}}{a matrix of weights controlling the amount of penalty element-wise.}

\item{\code{n_edges}}{number of edges if the network (non null coefficient of the sparse precision matrix)}

\item{\code{nb_param}}{number of parameters in the current PLN model}

\item{\code{pen_loglik}}{variational lower bound of the l1-penalized loglikelihood}

\item{\code{EBIC}}{variational lower bound of the EBIC}

\item{\code{density}}{proportion of non-null edges in the network}

\item{\code{criteria}}{a vector with loglik, penalized loglik, BIC, EBIC, ICL, R_squared, number of parameters, number of edges and graph density}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-PLNnetworkfit-new}{\code{PLNnetworkfit$new()}}
\item \href{#method-PLNnetworkfit-optimize}{\code{PLNnetworkfit$optimize()}}
\item \href{#method-PLNnetworkfit-latent_network}{\code{PLNnetworkfit$latent_network()}}
\item \href{#method-PLNnetworkfit-plot_network}{\code{PLNnetworkfit$plot_network()}}
\item \href{#method-PLNnetworkfit-show}{\code{PLNnetworkfit$show()}}
\item \href{#method-PLNnetworkfit-clone}{\code{PLNnetworkfit$clone()}}
}
}
\if{html}{\out{
<details><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="PLNmodels" data-topic="PLNfit" data-id="optimize_vestep"><a href='../../PLNmodels/html/PLNfit.html#method-PLNfit-optimize_vestep'><code>PLNmodels::PLNfit$optimize_vestep()</code></a></span></li>
<li><span class="pkg-link" data-pkg="PLNmodels" data-topic="PLNfit" data-id="predict"><a href='../../PLNmodels/html/PLNfit.html#method-PLNfit-predict'><code>PLNmodels::PLNfit$predict()</code></a></span></li>
<li><span class="pkg-link" data-pkg="PLNmodels" data-topic="PLNfit" data-id="predict_cond"><a href='../../PLNmodels/html/PLNfit.html#method-PLNfit-predict_cond'><code>PLNmodels::PLNfit$predict_cond()</code></a></span></li>
<li><span class="pkg-link" data-pkg="PLNmodels" data-topic="PLNfit" data-id="print"><a href='../../PLNmodels/html/PLNfit.html#method-PLNfit-print'><code>PLNmodels::PLNfit$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="PLNmodels" data-topic="PLNfit" data-id="update"><a href='../../PLNmodels/html/PLNfit.html#method-PLNfit-update'><code>PLNmodels::PLNfit$update()</code></a></span></li>
<li><span class="pkg-link" data-pkg="PLNmodels" data-topic="PLNfit_fixedcov" data-id="postTreatment"><a href='../../PLNmodels/html/PLNfit_fixedcov.html#method-PLNfit_fixedcov-postTreatment'><code>PLNmodels::PLNfit_fixedcov$postTreatment()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PLNnetworkfit-new"></a>}}
\if{latex}{\out{\hypertarget{method-PLNnetworkfit-new}{}}}
\subsection{Method \code{new()}}{
Initialize a \code{\link{PLNnetworkfit}} object
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PLNnetworkfit$new(data, control)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{a named list used internally to carry the data matrices}

\item{\code{control}}{a list for controlling the optimization.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PLNnetworkfit-optimize"></a>}}
\if{latex}{\out{\hypertarget{method-PLNnetworkfit-optimize}{}}}
\subsection{Method \code{optimize()}}{
Call to the C++ optimizer and update of the relevant fields
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PLNnetworkfit$optimize(data, config)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{a named list used internally to carry the data matrices}

\item{\code{config}}{a list for controlling the optimization}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PLNnetworkfit-latent_network"></a>}}
\if{latex}{\out{\hypertarget{method-PLNnetworkfit-latent_network}{}}}
\subsection{Method \code{latent_network()}}{
Extract interaction network in the latent space
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PLNnetworkfit$latent_network(type = c("partial_cor", "support", "precision"))}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{type}}{edge value in the network. Can be "support" (binary edges), "precision" (coefficient of the precision matrix) or "partial_cor" (partial correlation between species)}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
a square matrix of size \code{PLNnetworkfit$n}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PLNnetworkfit-plot_network"></a>}}
\if{latex}{\out{\hypertarget{method-PLNnetworkfit-plot_network}{}}}
\subsection{Method \code{plot_network()}}{
plot the latent network.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PLNnetworkfit$plot_network(
  type = c("partial_cor", "support"),
  output = c("igraph", "corrplot"),
  edge.color = c("#F8766D", "#00BFC4"),
  remove.isolated = FALSE,
  node.labels = NULL,
  layout = layout_in_circle,
  plot = TRUE
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{type}}{edge value in the network. Either "precision" (coefficient of the precision matrix) or "partial_cor" (partial correlation between species).}

\item{\code{output}}{Output type. Either \code{igraph} (for the network) or \code{corrplot} (for the adjacency matrix)}

\item{\code{edge.color}}{Length 2 color vector. Color for positive/negative edges. Default is \code{c("#F8766D", "#00BFC4")}. Only relevant for igraph output.}

\item{\code{remove.isolated}}{if \code{TRUE}, isolated node are remove before plotting. Only relevant for igraph output.}

\item{\code{node.labels}}{vector of character. The labels of the nodes. The default will use the column names ot the response matrix.}

\item{\code{layout}}{an optional igraph layout. Only relevant for igraph output.}

\item{\code{plot}}{logical. Should the final network be displayed or only sent back to the user. Default is \code{TRUE}.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PLNnetworkfit-show"></a>}}
\if{latex}{\out{\hypertarget{method-PLNnetworkfit-show}{}}}
\subsection{Method \code{show()}}{
User friendly print method
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PLNnetworkfit$show()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PLNnetworkfit-clone"></a>}}
\if{latex}{\out{\hypertarget{method-PLNnetworkfit-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PLNnetworkfit$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
