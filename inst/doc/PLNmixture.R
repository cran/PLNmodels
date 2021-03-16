## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  screenshot.force = FALSE,
  echo = TRUE,
  rows.print = 5,
  message = FALSE,
  warning = FALSE)

## ----requirement--------------------------------------------------------------
library(PLNmodels)
library(factoextra)

## ----future-------------------------------------------------------------------
library(future)
plan(multisession, workers = 2)

## ----data_load----------------------------------------------------------------
data(trichoptera)
trichoptera <- prepare_data(trichoptera$Abundance, trichoptera$Covariate)

## ----nocov mixture------------------------------------------------------------
mixture_models <- PLNmixture(
  Abundance ~ 1 + offset(log(Offset)),
  data  = trichoptera,
  clusters = 1:5
)

## ----show nocov---------------------------------------------------------------
mixture_models

## ----collection criteria------------------------------------------------------
mixture_models$criteria %>% knitr::kable()

## ----convergence criteria-----------------------------------------------------
mixture_models$convergence  %>% knitr::kable()

## ----objective----------------------------------------------------------------
mixture_models$plot_objective()

## ----plot nocov, fig.width=7, fig.height=5------------------------------------
plot(mixture_models)

## ----plot nocov-reverse, fig.width=7, fig.height=5----------------------------
plot(mixture_models, reverse = TRUE)

## ----model extraction---------------------------------------------------------
myMix_BIC <- getBestModel(mixture_models, "BIC")
myMix_2   <- getModel(mixture_models, 2)

## ----map, fig.width=8, fig.height=8-------------------------------------------
myMix_BIC

## -----------------------------------------------------------------------------
myMix_BIC$memberships

## -----------------------------------------------------------------------------
myMix_BIC$mixtureParam

## -----------------------------------------------------------------------------
myMix_BIC$posteriorProb %>% head() %>% knitr::kable(digits = 3)

## ----vcov---------------------------------------------------------------------
sigma(myMix_BIC) %>% purrr::map(as.matrix) %>% purrr::map(diag)

## ----coef, results='hide'-----------------------------------------------------
coef(myMix_BIC, 'main')       # equivalent to myMix_BIC$model_par$Theta
coef(myMix_BIC, 'mixture')    # equivalent to myMix_BIC$model_par$Pi, myMix_BIC$mixtureParam
coef(myMix_BIC, 'means')      # equivalent to myMix_BIC$model_par$Mu, myMix_BIC$group_means
coef(myMix_BIC, 'covariance') # equivalent to myMix_BIC$model_par$Sigma, sigma(myMix_BIC)

## ----group-means--------------------------------------------------------------
myMix_BIC$group_means %>% head() %>% knitr::kable(digits = 2)

## -----------------------------------------------------------------------------
myMix_BIC$components[[1]]

## ----plot clustering----------------------------------------------------------
plot(myMix_BIC, "pca")

## ----plot reordered data------------------------------------------------------
plot(myMix_BIC, "matrix")

## ----predict_class_posterior--------------------------------------------------
predicted.class <- predict(myMix_BIC, newdata = trichoptera)
## equivalent to 
## predicted.class <- predict(myMIX_BIC, newdata = trichoptera,  type = "posterior")
predicted.class %>% head() %>% knitr::kable(digits = 2)

## ----predict_class------------------------------------------------------------
predicted.class <- predict(myMix_BIC, newdata = trichoptera, 
                           prior = myMix_BIC$posteriorProb,  type = "response")
predicted.class

## ----predicted_position, fig.width=7, fig.height=5----------------------------
predicted.position <- predict(myMix_BIC, newdata = trichoptera, 
                              prior = myMix_BIC$posteriorProb, type = "position")
prcomp(predicted.position) %>% 
  factoextra::fviz_pca_ind(col.ind = predicted.class)

