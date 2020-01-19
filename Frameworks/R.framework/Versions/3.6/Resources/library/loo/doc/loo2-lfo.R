params <-
list(EVAL = TRUE)

## ---- SETTINGS-knitr, include=FALSE--------------------------------------
stopifnot(require(knitr))
opts_chunk$set(
  comment=NA,
  eval = if (isTRUE(exists("params"))) params$EVAL else FALSE,
  dev = "png",
  dpi = 150,
  fig.asp = 0.618,
  fig.width = 5,
  out.width = "60%",
  fig.align = "center"
)

## ----more-knitr-ops, include=FALSE---------------------------------------
knitr::opts_chunk$set(
  cache = TRUE,
  message = FALSE, 
  warning = FALSE
)

## ----pkgs, cache=FALSE---------------------------------------------------
library("loo")
library("brms")
library("bayesplot")
library("ggplot2")
color_scheme_set("brightblue")
theme_set(theme_default())

CHAINS <- 4
SEED <- 1234
set.seed(SEED)

## ----hurondata-----------------------------------------------------------
N <- length(LakeHuron)
df <- data.frame(
  y = as.numeric(LakeHuron),
  year = as.numeric(time(LakeHuron)),
  time = 1:N
)

# save plot labels to reuse them
plot_labs <- labs(
  y = "Water Level (ft)", 
  x = "Year",
  title = "Water Level in Lake Huron (1875-1972)"
) 

ggplot(df, aes(x = year, y = y)) + 
  geom_point(size = 1) +
  plot_labs

## ----fit, results = "hide"-----------------------------------------------
control <- list(adapt_delta = 0.95)
fit <- brm(
  y ~ 1, 
  data = df, 
  autocor = cor_ar(~time, p = 4), 
  prior = prior(normal(0, 0.5), class = "ar"),
  control = control, 
  seed = SEED, 
  chains = CHAINS
)

## ----plotpreds, cache = FALSE--------------------------------------------
preds <- posterior_predict(fit)
preds <- cbind(
  Estimate = colMeans(preds), 
  Q5 = apply(preds, 2, quantile, probs = 0.05),
  Q95 = apply(preds, 2, quantile, probs = 0.95)
)

ggplot(cbind(df, preds), aes(x = year, y = Estimate)) +
  geom_smooth(aes(ymin = Q5, ymax = Q95), stat = "identity", size = 0.5) +
  geom_point(aes(y = y)) + 
  labs(subtitle = "Mean (blue) and 90% predictive intervals (gray) vs. observed data (black)") +
  plot_labs

## ----setL----------------------------------------------------------------
L <- 20

## ----loo1sap, cache = FALSE----------------------------------------------
loo_cv <- loo(log_lik(fit)[, (L + 1):N])
print(loo_cv)

## ----exact_loglik, results="hide"----------------------------------------
loglik_exact <- matrix(nrow = nsamples(fit), ncol = N)
for (i in (N - 1):L) {
  past <- 1:i
  oos <- i + 1
  df_past <- df[past, , drop = FALSE]
  df_oos <- df[c(past, oos), , drop = FALSE]
  fit_i <- update(fit, newdata = df_past, recompile = FALSE)
  loglik_exact[, i + 1] <- log_lik(fit_i, newdata = df_oos, oos = oos)[, oos]
}

## ----helpers-------------------------------------------------------------
# some helper functions we'll use throughout

# more stable than log(sum(exp(x))) 
log_sum_exp <- function(x) {
  max_x <- max(x)  
  max_x + log(sum(exp(x - max_x)))
}

# more stable than log(mean(exp(x)))
log_mean_exp <- function(x) {
  log_sum_exp(x) - log(length(x))
}

# compute log of raw importance ratios
# sums over observations *not* over posterior samples
sum_log_ratios <- function(ll, ids = NULL) {
  if (!is.null(ids)) ll <- ll[, ids, drop = FALSE]
  - rowSums(ll)
}

# for printing comparisons later
rbind_print <- function(...) {
  round(rbind(...), digits = 2)
}

## ----exact1sap, cache = FALSE--------------------------------------------
exact_elpds_1sap <- apply(loglik_exact, 2, log_mean_exp)
exact_elpd_1sap <- c(ELPD = sum(exact_elpds_1sap[-(1:L)]))

rbind_print(
  "LOO" = loo_cv$estimates["elpd_loo", "Estimate"],
  "LFO" = exact_elpd_1sap
)

## ----loglik--------------------------------------------------------------
approx_elpds_1sap_no_refit <- rep(NA, N)
loglik <- log_lik(fit)
ks <- NULL

for (i in (N - 1):L) {
  logratio <- sum_log_ratios(loglik, (i + 1):N)
  psis_obj <- suppressWarnings(psis(logratio))
  ks <- c(ks, pareto_k_values(psis_obj))
  lw <- weights(psis_obj, normalize = TRUE)[, 1]
  approx_elpds_1sap_no_refit[i + 1] <- log_sum_exp(lw + loglik[, i + 1])
}

## ----plot_ks-------------------------------------------------------------
plot_ks <- function(ks, ids, thres = 0.6) {
  dat_ks <- data.frame(ks = ks, ids = ids)
  ggplot(dat_ks, aes(x = ids, y = ks)) + 
    geom_point(aes(color = ks > thres), shape = 3, show.legend = FALSE) + 
    geom_hline(yintercept = thres, linetype = 2, color = "red2") + 
    scale_color_manual(values = c("cornflowerblue", "darkblue")) + 
    labs(x = "Data point", y = "Pareto k") + 
    ylim(-0.5, 1.5)
}

## ----plotk1sap, cache = FALSE--------------------------------------------
plot_ks(ks, N:(L + 1))

## ----compare1sap, cache = FALSE------------------------------------------
approx_elpd_1sap_no_refit <- 
  c(ELPD = sum(approx_elpds_1sap_no_refit, na.rm = TRUE))
rbind_print(
  "approx LFO (no refit)" = approx_elpd_1sap_no_refit,
  "exact LFO" = exact_elpd_1sap
)

## ----setkthresh----------------------------------------------------------
k_thres <- 0.6

## ----refit_loglik, results="hide"----------------------------------------
loglik <- matrix(nrow = nsamples(fit), ncol = N)
approx_elpds_1sap <- rep(NA, N)
fit_past <- fit
i_refit <- N
refits <- ks <- NULL

for (i in (N - 1):L) {
  loglik[, i + 1] <- log_lik(fit_past)[, i + 1]
  logratio <- sum_log_ratios(loglik, (i + 1):i_refit)
  psis_obj <- suppressWarnings(psis(logratio))
  k <- pareto_k_values(psis_obj)
  ks <- c(ks, k)
  if (k > k_thres) {
    # refit the model based on the first i observations
    i_refit <- i
    refits <- c(refits, i)
    past <- 1:i
    oos <- i + 1
    df_past <- df[past, , drop = FALSE]
    df_oos <- df[c(past, oos), , drop = FALSE]
    fit_past <- update(fit_past, newdata = df_past, recompile = FALSE)
    loglik[, i + 1] <- log_lik(fit_past, newdata = df_oos)[, oos]
    approx_elpds_1sap[i + 1] <- log_mean_exp(loglik[, i + 1])
  } else {
    lw <- weights(psis_obj, normalize = TRUE)[, 1]
    approx_elpds_1sap[i + 1] <- log_sum_exp(lw + loglik[, i + 1])
  }
} 

## ----refitsummary1sap, cache=FALSE---------------------------------------
cat("Using threshold ", k_thres, 
    ", model was refit ", length(refits), 
    " times, at observations", refits)

plot_ks(ks, N:(L + 1))

## ----lfosummary1sap, cache = FALSE---------------------------------------
approx_elpd_1sap <- sum(approx_elpds_1sap, na.rm = TRUE)
rbind_print(
  "approx LFO (no refits)" = approx_elpd_1sap_no_refit,
  "approx LFO (with refits)" = approx_elpd_1sap,
  "exact LFO" = exact_elpd_1sap
)

## ----plot1sap, cache = FALSE---------------------------------------------
dat_elpd <- data.frame(
  approx_elpd = approx_elpds_1sap,
  exact_elpd = exact_elpds_1sap
)

ggplot(dat_elpd, aes(x = approx_elpd, y = exact_elpd)) +
  geom_abline(color = "gray30") +
  geom_point(size = 2) +
  labs(x = "Approximate ELPDs", y = "Exact ELPDs")

## ----diffs1sap, cache=FALSE----------------------------------------------
max_diff <- with(dat_elpd, max(abs(approx_elpd - exact_elpd), na.rm = TRUE))
mean_diff <- with(dat_elpd, mean(abs(approx_elpd - exact_elpd), na.rm = TRUE))

rbind_print(
  "Max diff" = round(max_diff, 2), 
  "Mean diff" =  round(mean_diff, 3)
)

## ----exact_loglikm, results="hide"---------------------------------------
M <- 4
loglikm <- matrix(nrow = nsamples(fit), ncol = N)
for (i in (N - M):L) {
  past <- 1:i
  oos <- (i + 1):(i + M)
  df_past <- df[past, , drop = FALSE]
  df_oos <- df[c(past, oos), , drop = FALSE]
  fit_past <- update(fit, newdata = df_past, recompile = FALSE)
  ll <- log_lik(fit_past, newdata = df_oos, oos = oos)
  loglikm[, i + 1] <- rowSums(ll[, oos])
}

## ----exact4sap, cache = FALSE--------------------------------------------
exact_elpds_4sap <- apply(loglikm, 2, log_mean_exp)
(exact_elpd_4sap <- c(ELPD = sum(exact_elpds_4sap, na.rm = TRUE)))

## ----refit_loglikm, results="hide"---------------------------------------
loglikm <- loglik <- matrix(nrow = nsamples(fit), ncol = N)
approx_elpds_4sap <- rep(NA, N)
fit_past <- fit
i_refit <- N
refits <- ks <- NULL

loglik[, (N - M + 2):N] <- log_lik(fit_past)[, (N - M + 2):N]
for (i in (N - M):L) {
  past <- 1:i
  oos <- (i + 1):(i + M)
  df_oos <- df[c(past, oos), , drop = FALSE]
  ll <- log_lik(fit_past, newdata = df_oos, oos = oos)
  loglik[, i + 1] <- ll[, i + 1]
  logratio <- sum_log_ratios(loglik, (i + 1):i_refit)
  psis_obj <- suppressWarnings(psis(logratio))
  k <- pareto_k_values(psis_obj)
  ks <- c(ks, k)
  if (k > k_thres) {
    # refit the model based on the first i observations
    i_refit <- i
    refits <- c(refits, i)
    df_past <- df[past, , drop = FALSE]
    fit_past <- update(fit, newdata = df_past, recompile = FALSE)
    ll <- log_lik(fit_past, newdata = df_oos, oos = oos)
    loglikm[, i + 1] <- rowSums(ll[, oos])
    loglik[, i + 1] <- ll[, i + 1]
    approx_elpds_4sap[i + 1] <- log_mean_exp(loglikm[, i + 1])
  } else {
    lw <- weights(psis_obj, normalize = TRUE)[, 1]
    loglikm[, i + 1] <- rowSums(ll[, oos])
    approx_elpds_4sap[i + 1] <- log_sum_exp(lw + loglikm[, i + 1])
  }
} 

## ----refitsummary4sap, cache = FALSE-------------------------------------
cat("Using threshold ", k_thres, 
    ", model was refit ", length(refits), 
    " times, at observations", refits)

plot_ks(ks, (N - M + 1):(L + 1))

## ----lfosummary4sap, cache = FALSE---------------------------------------
approx_elpd_4sap <- sum(approx_elpds_4sap, na.rm = TRUE)
rbind_print(
  "Approx LFO" = approx_elpd_4sap,
  "Exact LFO" = exact_elpd_4sap
)

## ----plot4sap, cache = FALSE---------------------------------------------
dat_elpd_4sap <- data.frame(
  approx_elpd = approx_elpds_4sap,
  exact_elpd = exact_elpds_4sap
)

ggplot(dat_elpd_4sap, aes(x = approx_elpd, y = exact_elpd)) +
  geom_abline(color = "gray30") +
  geom_point(size = 2) +
  labs(x = "Approximate ELPDs", y = "Exact ELPDs")

## ----sessioninfo---------------------------------------------------------
sessionInfo()

