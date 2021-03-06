% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/surv_reg.R
\name{surv_reg}
\alias{surv_reg}
\alias{update.surv_reg}
\title{General Interface for Parametric Survival Models}
\usage{
surv_reg(mode = "regression", dist = NULL, others = list(), ...)

\method{update}{surv_reg}(object, dist = NULL, others = list(),
  fresh = FALSE, ...)
}
\arguments{
\item{mode}{A single character string for the type of model.
The only possible value for this model is "regression".}

\item{dist}{A character string for the outcome distribution. "weibull" is
the default.}

\item{others}{A named list of arguments to be used by the
underlying models (e.g., \code{flexsurv::flexsurvreg}). These are not evaluated
until the model is fit and will be substituted into the model
fit expression.}

\item{...}{Used for S3 method consistency. Any arguments passed to
the ellipses will result in an error. Use \code{others} instead.}

\item{object}{A survival regression model specification.}

\item{fresh}{A logical for whether the arguments should be
modified in-place of or replaced wholesale.}
}
\value{
An updated model specification.
}
\description{
\code{surv_reg} is a way to generate a \emph{specification} of a model
before fitting and allows the model to be created using
R. The main argument for the
model is:
\itemize{
\item \code{dist}: The probability distribution of the outcome.
}
This argument is converted to its specific names at the
time that the model is fit. Other options and argument can be
set using the \code{others} argument. If left to its default
here (\code{NULL}), the value is taken from the underlying model
functions.

If parameters need to be modified, this function can be used
in lieu of recreating the object from scratch.
}
\details{
The data given to the function are not saved and are only used
to determine the \emph{mode} of the model. For \code{surv_reg},the
mode will always be "regression".

Since survival models typically involve censoring (and require the use of
\code{\link[survival:Surv]{survival::Surv()}} objects), the \code{\link[=fit]{fit()}} function will require that the
survival model be specified via the formula or recipes interfaces.

For recipes, right censoring indicators should be specified
using the "censoring var" role (see examples below). Also, for
the engine that uses \code{flexsurv::flexsurvfit}, extra roles can
be used for non-location parameters (e.g. \code{sigma} or \code{sdlog}) so
that other distributional parameters can be functions or
covariates. See the example below as well as Jackson (2016).

Also, for the \code{flexsurv::flexsurvfit} engine, the typical
\code{strata} function cannot be used. To achieve the same effect,
the extra parameter roles can be used (as described above).

The model can be created using the \code{\link[=fit]{fit()}} function using the
following \emph{engines}:
\itemize{
\item \pkg{R}:  \code{"flexsurv"}
}
}
\examples{
surv_reg()
# Parameters can be represented by a placeholder:
surv_reg(dist = varying())

# Examples of using recipes with the `fit` function

library(dplyr)
library(recipes)
library(survival)
data(lung)

surv_rec <- recipe(time ~ ., data = lung) \%>\%
  add_role(status, new_role = "censoring var") \%>\%
  # exclude some vars from being in the model
  add_role(inst, sex, ph.karno, pat.karno, meal.cal, wt.loss,
           new_role = "other variables")

log_normal_mod <- surv_reg(dist = "lnorm")

fit(log_normal_mod, recipe = surv_rec, data = lung, engine = "flexsurv")

# make the normal variance be a function of gender:

strata_model <- surv_rec \%>\%
  add_role(sex, new_role = "sdlog")

fit(log_normal_mod, recipe = strata_model, data = lung, engine = "flexsurv")

model <- surv_reg(dist = "weibull")
model
update(model, dist = "lnorm")
}
\references{
Jackson, C. (2016). \code{flexsurv}: A Platform for Parametric Survival
Modeling in R. \emph{Journal of Statistical Software}, 70(8), 1 - 33.
}
\seealso{
\code{\link[=varying]{varying()}}, \code{\link[=fit]{fit()}}, \code{\link[survival:Surv]{survival::Surv()}}
}
