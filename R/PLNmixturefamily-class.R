#' An R6 Class to represent a collection of PLNmixturefit
#'
#' @description The function [PLNmixture()] produces an instance of this class.
#'
#' This class comes with a set of methods, some of them being useful for the user:
#' See the documentation for [getBestModel()], [getModel()] and [`plot()`][plot.PLNmixturefamily()].
#'
#' @param responses the matrix of responses common to every models
#' @param covariates the matrix of covariates common to every models
#' @param offsets the matrix of offsets common to every models
#' @param control a list for controlling the optimization. See details.
#' @param clusters the dimensions of the successively fitted models
#' @param formula model formula used for fitting, extracted from the formula in the upper-level call
#' @param control a list for controlling the optimization. See details.
#' @param xlevels named listed of factor levels included in the models, extracted from the formula in the upper-level call #'
#' @include PLNfamily-class.R
#' @importFrom R6 R6Class
#' @importFrom purrr map map_dbl map_int
#' @import ggplot2
#' @seealso The function \code{\link{PLNmixture}}, the class \code{\link[=PLNmixturefit]{PLNmixturefit}}
PLNmixturefamily <-
  R6Class(classname = "PLNmixturefamily",
    inherit = PLNfamily,
    active = list(
      #' @field clusters vector indicating the number of clusters considered is the successively fitted models
      clusters = function() private$params
    ),
    private = list(
      formula = NULL,
      xlevels = NULL,

      smooth_forward = function(control) {

        trace <- control$trace > 0; control$trace <- FALSE
        control_fast <- control
        control_fast$maxit_out <- 2

        if (trace) cat("   Going forward ")
        for (k in self$clusters[-length(self$clusters)]) {
          if (trace) cat("+")
          ## current clustering
          cl  <- self$models[[k]]$memberships
          ## all best split according to kmeans
          data_split <- self$models[[k]]$latent_pos %>% as.data.frame() %>% split(cl)
          cl_splitable <- (1:k)[tabulate(cl) >= 3]
          cl_split <- vector("list", k)
          cl_split[cl_splitable] <- data_split[cl_splitable] %>% map(kmeans, 2, nstart = 10) %>% map("cluster")

          ## Reformating into indicator of clusters
          tau_candidates <- map(cl_splitable, function(k_)  {
            split <- cl_split[[k_]]
            split[cl_split[[k_]] == 1] <- k_
            split[cl_split[[k_]] == 2] <- k + 1
            candidate <- cl
            candidate[candidate == k_] <- split
            candidate
          }) %>% map(as_indicator)

          loglik_candidates <- future.apply::future_lapply(tau_candidates, function(tau_) {
            model <- PLNmixturefit$new(self$responses, self$covariates, self$offsets, tau_, private$formula, private$xlevels, control_fast)
            model$optimize(self$responses, self$covariates, self$offsets, control_fast)
            model$loglik
          }, future.seed = TRUE, future.scheduling = structure(TRUE, ordering = "random")) %>% unlist()

          best_one <- PLNmixturefit$new(self$responses, self$covariates, self$offsets, tau_candidates[[which.max(loglik_candidates)]], private$formula, private$xlevels, control)
          best_one$optimize(self$responses, self$covariates, self$offsets, control)

          if (best_one$loglik > self$models[[k + 1]]$loglik) {
            self$models[[k + 1]] <- best_one
            # cat("found one")
          }

      }
      if (trace) cat("\r                                                                                                    \r")
      },
      smooth_backward = function(control) {
        trace <- control$trace > 0; control$trace <- FALSE
        control_fast <- control
        control_fast$maxit_out <- 2
        if (trace) cat("   Going backward ")
        for (k in rev(self$clusters[-1])) {
          if (trace) cat('+')

          tau <- self$models[[k]]$posteriorProb
          tau_candidates <- lapply(combn(k, 2, simplify = FALSE), function(couple) {
            i <- min(couple); j <- max(couple)
            tau_merged <- tau[, -j, drop = FALSE]
            tau_merged[, i] <- rowSums(tau[, c(i,j)])
            tau_merged
          })

          loglik_candidates <- future.apply::future_lapply(tau_candidates, function(tau_) {
            model <- PLNmixturefit$new(self$responses, self$covariates, self$offsets, tau_, private$formula, private$xlevels, control_fast)
            model$optimize(self$responses, self$covariates, self$offsets, control_fast)
            model$loglik
          }, future.seed = TRUE, future.scheduling = structure(TRUE, ordering = "random")) %>% unlist()

          best_one <- PLNmixturefit$new(self$responses, self$covariates, self$offsets, tau_candidates[[which.max(loglik_candidates)]], private$formula, private$xlevels, control)
          best_one$optimize(self$responses, self$covariates, self$offsets, control)

          if (best_one$loglik > self$models[[k - 1]]$loglik) {
              self$models[[k - 1]] <- best_one
              # cat("found one")
          }

        }
        if (trace) cat("\r                                                                                                    \r")
      }

    ),
  ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ## PUBLIC MEMBERS ----
  ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public = list(
    ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ## Creation -----------------------
    #' @description Initialize all models in the collection.
      initialize = function(clusters, responses, covariates, offsets, formula, xlevels, control) {

        ## initialize the required fields
        super$initialize(responses, covariates, offsets, rep(1, nrow(responses)), control)
        private$params  <- clusters
        private$formula <- formula
        private$xlevels <- xlevels

        myPLN <- PLNfit$new(responses, covariates, offsets, rep(1, nrow(responses)), formula, xlevels, control)
        myPLN$optimize(responses, covariates, offsets, rep(1, nrow(responses)), control)

        if(control$covariance == 'spherical')
          Sbar <- c(myPLN$var_par$S2) * myPLN$p
        else
          Sbar <- rowSums(myPLN$var_par$S2)

        D <- sqrt(as.matrix(dist(myPLN$var_par$M)^2) + outer(Sbar,rep(1,myPLN$n)) + outer(rep(1, myPLN$n), Sbar))

        if (is.numeric(control$init_cl)) {
          clusterings <- control$init_cl
        } else if (is.character(control$init_cl)) {
          clusterings <-switch(control$init_cl,
            "kmeans"  = lapply(clusters, function(k) kmeans(D, centers = k, nstart = 30)$cl),
            "ward.D2" = D %>% as.dist() %>% hclust(method = "ward.D2") %>% cutree(clusters) %>% as.data.frame() %>% as.list()
          )
        }
        self$models <-
          clusterings %>%
            map(as_indicator) %>%
            map(.check_boundaries) %>%
            map(function(Z) PLNmixturefit$new(responses, covariates, offsets, Z, formula, xlevels, control))
      },
      ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      ## Optimization ----------------------
      #' @description Call to the optimizer on all models of the collection
      optimize = function(control) {
        ## go along the number of clusters (i.e the models)
        for (m in seq_along(self$models))  {
          if (control$trace == 1) {
            cat("\tnumber of cluster =", self$models[[m]]$k, "\r")
            flush.console()
          }
          if (control$trace > 1) {
            cat("\tnumber of cluster =", self$models[[m]]$k, "- iteration:")
          }

          self$models[[m]]$optimize(self$responses, self$covariates, self$offsets, control)

          if (control$trace > 1) {
            cat("\r                                                                                    \r")
            flush.console()
          }

        }
      },
      #' @description
      #' function to restart clustering to avoid local minima by smoothing the loglikelihood values as a function of the number of clusters
      #' @param control a list to control the smoothing process
      smooth = function(control) {
        if (control$trace > 0) control$trace <- TRUE else control$trace <- FALSE
        for (i in seq_len(control$iterates)) {
          if (control$smoothing %in% c('backward', 'both')) private$smooth_backward(control)
          if (control$smoothing %in% c('forward' , 'both')) private$smooth_forward(control)
        }
      },
      ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      ## Graphical methods -------------
      #' @description
      #' Lineplot of selected criteria for all models in the collection
      #' @param criteria A valid model selection criteria for the collection of models. Any of "loglik", "BIC" or "ICL" (all).
      #' @param reverse A logical indicating whether to plot the value of the criteria in the "natural" direction
      #' (loglik - 0.5 penalty) or in the "reverse" direction (-2 loglik + penalty). Default to FALSE, i.e use the
      #' natural direction, on the same scale as the log-likelihood..
      #' @return A [`ggplot2`] object
      plot = function(criteria = c("loglik", "BIC", "ICL"), reverse = FALSE) {
        vlines <- map_int(intersect(criteria, c("BIC", "ICL")), function(crit) self$getBestModel(crit)$k)
        p <- super$plot(criteria, reverse) + xlab("# of clusters") + geom_vline(xintercept = vlines, linetype = "dashed", alpha = 0.25)
        p
       },
      #' @description Plot objective value of the optimization problem along the penalty path
      #' @return a [`ggplot`] graph
      plot_objective = function() {
        objective <- self$models %>% map('optim_par') %>% map('objective') %>% unlist
        changes   <- self$models %>% map('optim_par') %>% map('outer_iterations') %>% unlist %>% cumsum
        dplot <- data.frame(iteration = 1:length(objective), objective = objective)
        p <- ggplot(dplot, aes(x = iteration, y = objective)) + geom_line() +
          geom_vline(xintercept = changes, linetype="dashed", alpha = 0.25) +
          ggtitle("Objective along the alternate algorithm") + xlab("iteration (+ changes of model)") + theme_bw()
        p
      },

      ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      ## Extractors   -------------------
      #' @description Extract best model in the collection
      #' @param crit a character for the criterion used to performed the selection. Either
      #' "BIC", "ICL" or "loglik". Default is `ICL`
      #' @return a [`PLNmixturefit`] object
      getBestModel = function(crit = c("BIC", "ICL", "loglik")){
        crit <- match.arg(crit)
        stopifnot(!anyNA(self$criteria[[crit]]))
        id <- 1
        if (length(self$criteria[[crit]]) > 1) {
          id <- which.max(self$criteria[[crit]])
        }
        model <- self$models[[id]]$clone()
        model
      },
      ## %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      ## Print methods ---------------------
      #' @description User friendly print method
      show = function() {
        super$show()
        cat(" Task: Mixture Model \n")
        cat("========================================================\n")
        cat(" - Number of clusters considered: from", min(self$clusters), "to", max(self$clusters),"\n")
        cat(" - Best model (regarding BIC): cluster =", self$getBestModel("BIC")$k, "\n")
        cat(" - Best model (regarding ICL): cluster =", self$getBestModel("ICL")$k, "\n")
      },
      #' @description User friendly print method
      print = function() self$show()
    )
)

