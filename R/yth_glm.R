#' Fits Hamilton's alternative model
#'
#' \code{yth_glm} fits a generalized linear model suggested by James D. Hamilton as a better alternative to the Hodrick-Prescott Filter.
#'
#' For time series of quarterly periodicity, Hamilton suggests parameters of
#'  h = 8 and p = 4, or an \eqn{AR(4)} process, additionally lagged by \eqn{8}
#'  lookahead periods. Econometricians may explore variations of h. However, p is designed to correspond with the seasonality of a given periodicity and should be matched accordingly.
#'  \deqn{y_{t+h} = \beta_0 + \beta_1 y_t + \beta_2 y_{t-1} + \beta_3 y_{t-2} + \beta_4 y_{t-3} + v_{t+h}}
#'  \deqn{\hat{v}_{t+h} = y_{t+h} - \hat{\beta}_0 + \hat{\beta}_1 y_t + \hat{\beta}_2 y_{t-1} + \hat{\beta}_3 y_{t-2} + \hat{\beta}_4 y_{t-3}}
#'  Which can be rewritten as:
#'  \deqn{y_{t} = \beta_0 + \beta_1 y_{t-8} + \beta_2 y_{t-9} + \beta_3 y_{t-10} + \beta_4 y_{t-11} + v_{t}}
#'  \deqn{\hat{v}_{t} = y_{t} - \hat{\beta}_0 + \hat{\beta}_1 y_{t-8} + \hat{\beta}_2 y_{t-9} + \hat{\beta}_3 y_{t-10} + \hat{\beta}_4 y_{t-11}}
#'
#' @return \code{yth_glm} returns a generalized linear model object of class \code{\link{glm}},
#'  which inherits from \code{\link{lm}}.
#'
#' @param x A univariate \code{\link{xts}} object of any \code{\link{zoo}} index class,
#'  such as \code{\link{Date}}, \code{\link{yearmon}}, or \code{\link{yearqtr}}.
#'  For converting objects of type \code{timeSeries, ts, irts, fts, matrix, data.frame}
#'  or \code{zoo} to \code{\link{xts}}, please read  \code{\link{as.xts}}.
#'
#' @param h An \code{\link{integer}}, defining the lookahead period.
#'  Defaults to \code{h = 8}, suggested by Hamilton. The default assumes
#'  economic data of quarterly periodicity with a lookahead period of 2 years.
#'  This function is not limited by the default parameter, and Econometricians may
#'  change it as required.
#'
#' @param p An \code{\link{integer}}, indicating the number of lags. A Default of \code{p = 4},
#'  suggested by Hamilton, assumes data is of quarterly periodicity. If data is
#'  of monthly periodicity, one may choose \code{p = 12} or aggregate the series
#'  to quarterly periodicity and maintain the default. Econometricians should
#'  use this parameter to accommodate the Seasonality of their data.
#'
#'
#' @param ... all arguments passed to the function \code{\link[stats]{glm}}
#'
#' @inheritParams glm
#'
#' @seealso \code{\link{glm}}
#'
#' @importFrom stats lag
#'
#' @references James D. Hamilton. \href{http://econweb.ucsd.edu/~jhamilto/hp.pdf}{Why You Should Never Use the Hodrick-Prescott Filter}.
#'  NBER Working Paper No. 23429, Issued in May 2017.
#'
#'@examples
#' data(GDPC1)
#'
#' gdp_model <- yth_glm(GDPC1, h = 8, p = 4, family = gaussian)
#'
#' summary(gdp_model)
#'
#' plot(gdp_model)
#'
#'@export
yth_glm <- function(x, h = 8, p = 4, ...) {

           if(!"xts" %in% class(x)) {

              stop(paste("Argument 'x' must be an object of type xts.", class(x), "is not an xts object"))

    } else if(h %% 1 != 0) {

              stop(paste("Argument 'h' must be a whole number.", h, "is not a whole number."))

    } else if(p %% 1 != 0) {

              stop(paste("Argument 'p' must be a whole number.", p, "is not a whole number."))

    } else {

            data  <- lag(x, k = c(0, h:(h+p-1)), na.pad = TRUE)

            colnames(data)  <- c(paste0("yt",h), paste0('xt_',0:(p-1)))

            formula <- paste0(c(paste0(paste0("yt",h)," ~ xt_0"), paste0('+ xt_',1:(p-1))), collapse = " ")

            stats::glm(formula, data = data, ...)

        }
}

