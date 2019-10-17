### R code from vignette source 'outreg.Rnw'
### Encoding: UTF-8

###################################################
### code chunk number 1: outreg.Rnw:26-27
###################################################
  if(exists(".orig.enc")) options(encoding = .orig.enc)


###################################################
### code chunk number 2: tmpout
###################################################
if(!dir.exists("tmpout")) dir.create("tmpout", showWarnings=FALSE)


###################################################
### code chunk number 3: Roptions
###################################################
opts.orig <- options()
options(width=100, prompt=" ", continue="  ")
options(useFancyQuotes = FALSE) 
set.seed(12345)
options(SweaveHooks=list(fig=function() par(ps=10)))
pdf.options(onefile=FALSE,family="Times",pointsize=10)


###################################################
### code chunk number 4: outreg.Rnw:486-503
###################################################
fn1 <- "theme/logoleft.pdf"
fn2 <- "theme/logo-vert.pdf"
if(!file.exists("theme")) dir.create("theme")

blankpdf <- function(file, height=3, width=3, pointsize=20, replace = FALSE){
    if(file.exists(file) && !replace) return(TRUE)
    pdf(file=file, width=width, height=height, paper="special", 
        onefile=FALSE, pointsize=pointsize)
    par(mar=c(1,1,1,1))
    plot(1:2, 1:2, type = "n", axes=FALSE, xlab="", ylab="")
    ##text(1.5, 1.5, "left\n logo", axes=FALSE) 
    ##box(which="plot")
    dev.off()
    if(file.exists(file)) TRUE else FALSE
}
blankpdf(fn1)
blankpdf(fn2)


###################################################
### code chunk number 5: outreg.Rnw:659-667
###################################################
set.seed(2134234)
dat <- data.frame(x1 = rnorm(100), x2 = rnorm(100))
dat$y1 <- 30 + 5 * rnorm(100) + 3 * dat$x1 + 4 * dat$x2
dat$y2 <- rnorm(100) + 5 * dat$x2
m1 <- lm(y1 ~ x1, data = dat)
m2 <- lm(y1 ~ x2, data = dat)
m3 <- lm(y1 ~ x1 + x2, data = dat)
gm1 <- glm(y1 ~ x1, family = Gamma, data = dat)


###################################################
### code chunk number 6: ex1
###################################################
library(rockchalk)
vl <- c("(Intercept)" = "Intercept")
ex1 <- outreg(m1, title = "My One Tightly Printed Regression (uncentered)",
                    label = "tab:ex1",
                    float = TRUE, print.results = FALSE, varLabels=vl)
# cat that, don't print it
cat(ex1)


###################################################
### code chunk number 7: ex1w
###################################################
library(rockchalk)
ex1w <- outreg(m1, title = "My Wide Format \"side-by-side\" columns (uncentered)", label = "tab:ex1w", tight = FALSE, float = TRUE, print.results = FALSE)
cat(ex1w)


###################################################
### code chunk number 8: ex1d
###################################################
library(rockchalk)
ex2d <- outreg(m1, title = 'Tight column with centering = "dcolumn"', label = "tab:ex2d", centering = "dcolumn", float = TRUE, print.results=FALSE)
cat(ex2d)


###################################################
### code chunk number 9: ex1s
###################################################
library(rockchalk)
ex2s <- outreg(m1, title = 'Tight column with centering = "siunitx"', label = "tab:ex2s", centering = "siunitx", float = TRUE)


###################################################
### code chunk number 10: ex2wd
###################################################
library(rockchalk)
ex1wd <- outreg(m1, title = 'Wide (not tight) format with centering = "dcolumn"',  label = "tab:ex2wd", tight = FALSE, centering = "dcolumn",  float = TRUE, print.results = FALSE)
cat(ex1wd)


###################################################
### code chunk number 11: ex2ws
###################################################
ex1ws <- outreg(m1, title = 'Wide (not tight) format with centering = "siunitx"',  label = "tab:ex2ws", tight = FALSE, centering = "siunitx", float = TRUE, print.results = FALSE)
cat(ex1ws)


###################################################
### code chunk number 12: outreg.Rnw:739-740
###################################################
ex2p <- outreg(list("Fingers" = m1), tight = FALSE, title = "Ability to change p values (not centered)", label = "tab:ex2p",  float = TRUE, alpha = c(0.1, 0.05, 0.01)) 


###################################################
### code chunk number 13: outreg.Rnw:743-744
###################################################
ex2pd <- outreg(list("Fingers" = m1), tight = FALSE,  title = "Ability to change p values (dcolumn)", label = "tab:ex2pd", centering = "dcolumn", float = TRUE, alpha = c(0.1, 0.05, 0.01)) 


###################################################
### code chunk number 14: outreg.Rnw:747-748
###################################################
ex2ps <- outreg(list("Fingers" = m1), tight = FALSE,  title = "Ability to change p values (siunitx)", label = "tab:ex2ps", centering = "siunitx", float = TRUE, alpha = c(0.1, 0.05, 0.01)) 


###################################################
### code chunk number 15: outreg.Rnw:766-768
###################################################
ex3 <- outreg(list("Model A" = m1, "Model B has a longer heading" = m2), varLabels = list(x1 = "Billie"),   title = "My Two Linear Regressions (uncentered)", label = "tab:ex3", request = c(fstatistic = "F"),  print.results = FALSE)
cat(ex3)


###################################################
### code chunk number 16: outreg.Rnw:778-780
###################################################
ex3b <- outreg(list("Model A" = m1, "Model B" = m2),   modelLabels = c("Overrides ModelA", "Overrides ModelB"), varLabels = list(x1 = "Billie"), title = "Note modelLabels Overrides model names (uncentered)",  label = "tab:ex3b"
)


###################################################
### code chunk number 17: outreg.Rnw:786-787
###################################################
ex3bd <- outreg(list("Model A" = m1, "Model B" = m2), modelLabels = c("Overrides ModelA", "Overrides ModelB"), varLabels = list(x1 = "Billie"), title = "Note modelLabels Overrides model names (dcolumn)", label = "tab:ex3bd", centering = "dcolumn")


###################################################
### code chunk number 18: outreg.Rnw:790-791
###################################################
ex3bs <- outreg(list("Model A" = m1, "Model B" = m2), modelLabels = c("Overrides ModelA", "Overrides ModelB"),  varLabels = list(x1 = "Billie"), title = "Note modelLabels Overrides model names (siunitx)", label = "tab:ex3bs", centering = "siunitx")


###################################################
### code chunk number 19: ex5d
###################################################
ex5d <- outreg(list("Whichever" = m1, "Whatever" = m2), title = "Still have showAIC argument (uncentered)", label = "tab:ex5d", showAIC = TRUE, float = TRUE)


###################################################
### code chunk number 20: ex5dd
###################################################
ex5dd <- outreg(list("Whichever" = m1, "Whatever" = m2),  title = "Still have showAIC argument (dcolumn)", label = "tab:ex5dd", showAIC = TRUE, float = TRUE, centering = "dcolumn")


###################################################
### code chunk number 21: ex5ds
###################################################
ex5ds <- outreg(list("Whichever" = m1, "Whatever" = m2), title = "Still have showAIC argument (siunitx)", label = "tab:ex5ds", showAIC = TRUE, float = TRUE, centering = "siunitx")


###################################################
### code chunk number 22: ex6d
###################################################
ex6d <- outreg(list("Whatever" = m1, "Whatever" =m2), title = "Another way to get AIC output", label="ex6d",  runFuns = c("AIC" = "Akaike IC"), centering = "dcolumn", print.results=FALSE)
cat(ex6d)


###################################################
### code chunk number 23: outreg.Rnw:854-855
###################################################
ex7 <- outreg(list("Amod" = m1, "Bmod" = m2, "Gmod" = m3), title = "My Three Linear Regressions", label="tab:ex7")


###################################################
### code chunk number 24: outreg.Rnw:861-862
###################################################
ex7d <- outreg(list("Amod" = m1, "Bmod" = m2, "Gmod" = m3), centering = "dcolumn", title = "My Three Linear Regressions (decimal aligned)", label="tab:ex7d")


###################################################
### code chunk number 25: outreg.Rnw:875-876
###################################################
ex11 <- outreg(list("I Love Long Titles" = m1, "Prefer Brevity" = m2, "Captain. Kirk. Named. This." = m3), tight = FALSE, float = FALSE, centering = "dcolumn")


###################################################
### code chunk number 26: outreg.Rnw:882-883
###################################################
ex11td <- outreg(list("I Love Long Titles" = m1, "Prefer Brevity" = m2, "Captain. Kirk. Named. This" = m3), float = FALSE,  centering = "dcolumn")


###################################################
### code chunk number 27: outreg.Rnw:889-890
###################################################
ex11ts <- outreg(list("I Love Long Titles" = m1, "Prefer Brevity" = m2, "Captain. Kirk. Named. This" = m3), float = FALSE, centering = "siunitx")


###################################################
### code chunk number 28: outreg.Rnw:908-914
###################################################
if (require(car)){
   newSE <- sqrt(diag(car::hccm(m3)))
   ex8 <- outreg(list("Model A" = m1, "Model B" = m2, "Model C" = m3, 
             "Model C w Robust SE" = m3),
             SElist= list("Model C w Robust SE" = newSE))
}


###################################################
### code chunk number 29: outreg.Rnw:920-927
###################################################
if (require(car)){
   newSE <- sqrt(diag(car::hccm(m3)))
   ex8 <- outreg(list("Model A" = m1, "Model B" = m2, "Model C" = m3, 
             "Model C w Robust SE" = m3),
             SElist= list("Model C w Robust SE" = newSE),
             centering = "dcolumn")
}


###################################################
### code chunk number 30: outreg.Rnw:933-940
###################################################
if (require(car)){
   newSE <- sqrt(diag(car::hccm(m3)))
   ex8 <- outreg(list("Model A" = m1, "Model B" = m2, "Model C" = m3, 
             "Model C w Robust SE" = m3),
             SElist= list("Model C w Robust SE" = newSE),
             centering = "siunitx")
}


###################################################
### code chunk number 31: outreg.Rnw:952-955
###################################################
ex13 <- outreg(list("OLS" = m1, "GLM" = gm1), float = TRUE,
               title = "OLS and Logit in same table (dcolumn)", 
               label="tab:ex13", alpha = c(0.05, 0.01), centering = "dcolumn")


###################################################
### code chunk number 32: outreg.Rnw:961-966
###################################################
ex14 <- outreg(list(OLS = m1, GLM = gm1), float = TRUE,
         title = "OLS and Logit with summary report features (dcolumn)",
         label = "tab:ex14",
         request = c(fstatistic = "F"), runFuns = c("BIC" = "BIC"),
         centering = "dcolumn")


###################################################
### code chunk number 33: outreg.Rnw:972-977
###################################################
ex15 <- outreg(list(OLS = m1, GLM = gm1), float = TRUE,
         title="OLS and GLM with more digits (digits)", 
         label="tab:ex15", 
         request = c(fstatistic = "F"), runFuns = c("BIC" = "BIC"),
         digits = 5, alpha = c(0.01), centering = "dcolumn")


###################################################
### code chunk number 34: outreg.Rnw:984-990
###################################################
ex16d <- outreg(list("OLS 1" = m1, "OLS 2" = m2,  GLM = gm1), float = TRUE,
           title = "2 OLS and 1 Logit (dcolumn), additional runFuns", 
           label="tab:ex16d",
           request = c(fstatistic = "F"),
           runFuns = c("BIC" = "BIC", "logLik" = "ll"),
           digits = 5, alpha = c(0.1, 0.05, 0.01), centering = "dcolumn")


###################################################
### code chunk number 35: outreg.Rnw:993-999
###################################################
ex16s <- outreg(list("OLS 1" = m1, "OLS 2" = m2,  GLM = gm1), float = TRUE,
           title = "2 OLS and 1 Logit (siunitx), additional runFuns", 
           label="tab:ex16s",
           request = c(fstatistic = "F"),
           runFuns = c("BIC" = "BIC", "logLik" = "ll"),
           digits = 5, alpha = c(0.1, 0.05, 0.01), centering = "siunitx")


###################################################
### code chunk number 36: outreg.Rnw:1011-1015
###################################################
ex17 <- outreg(list("Model A" = gm1, "Model B label with Spaces" = m2),
         request = c(fstatistic = "F"),
         runFuns = c("BIC" = "Schwarz IC", "AIC" = "Akaike IC", "logLik" = "ll",
         "nobs" = "N Again?"), centering = "dcolumn")


###################################################
### code chunk number 37: outreg.Rnw:1021-1025
###################################################
ex17s <- outreg(list("Model A" = gm1, "Model B label with Spaces" = m2),
         request = c(fstatistic = "F"),
         runFuns = c("BIC" = "Schwarz IC", "AIC" = "Akaike IC", "logLik" = "ll",
         "nobs" = "N Again?"), centering = "siunitx")


###################################################
### code chunk number 38: session
###################################################
sessionInfo()
if(!is.null(warnings())){
    print("Warnings:")
    warnings()}


###################################################
### code chunk number 39: opts20
###################################################
## Don't delete this. It puts the interactive session options
## back the way they were. If this is compiled within a session
## it is vital to do this.
options(opts.orig)


