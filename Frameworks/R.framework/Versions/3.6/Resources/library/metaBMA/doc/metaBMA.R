## ---- fig.height=3.5, fig.width=5----------------------------------------
# load package
library("metaBMA")
# load data set
data(towels)

# Half-normal (truncated to > 0)
p1 <- prior("norm", c(mean=0, sd=.3), lower = 0)
p1
p1(1:3)
plot(p1)

# custom prior
p1 <- prior("custom", function(x) x^3-2*x+3, lower = 0, upper = 1)
plot(p1, -.5, 1.5)

## ---- fig.height=3.5, fig.width=5----------------------------------------
# Fixed-effects
progres <- capture.output(  # suppress Stan progress for vignette
  mf <- meta_fixed(logOR, SE, study, towels, 
                   d = prior("norm", c(mean=0, sd=.3), lower=0))
)
mf

# plot posterior distribution
plot_posterior(mf)

## ---- fig.height=3.5, fig.width=5----------------------------------------
# Random-effects
progres <- capture.output(  # suppress Stan progress for vignette
  mr <- meta_random(logOR, SE, study, towels,
                    d = prior("norm", c(mean=0, sd=.3), lower=0),
                    tau = prior("t", c(location=0, scale=.3, nu=1), lower=0))
)
mr

# plot posterior distribution
plot_posterior(mr, main = "Average effect size d")
plot_posterior(mr, "tau", main = "Heterogeneity tau")

## ---- fig.height=4.5, fig.width=6----------------------------------------
mb <- meta_bma(logOR, SE, study, towels,
               d = prior("norm", c(mean=0, sd=.3), lower=0),
               tau = prior("t", c(location=0, scale=.3, nu=1), lower=0))
mb
plot_posterior(mb, "d", -.1, 1.4)
plot_forest(mb)

## ---- eval = FALSE, fig.height=4.5, fig.width=6--------------------------
#  mp <- predicted_bf(mb, SE = .2, sample = 30)
#  plot(mp)

