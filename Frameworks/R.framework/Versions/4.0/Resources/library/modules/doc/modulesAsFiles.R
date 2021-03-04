## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
code <- "
import('stats', 'median')
functionWithDep <- function(x) median(x)
"

fileName <- tempfile(fileext = ".R")
writeLines(code, fileName)

## -----------------------------------------------------------------------------
library(modules)
m <- use(fileName)
m$functionWithDep(1:2)

## ----eval = FALSE-------------------------------------------------------------
#  lib <- modules::use("R")
#  dat <- read.csv("data/some.csv")
#  
#  # munging
#  dat <- lib$munging$clean(dat)
#  dat <- lib$munging$recode(dat)
#  
#  # generate results
#  lib$graphics$barplot(dat)
#  lib$graphics$lineplot(dat)

## ----eval = FALSE-------------------------------------------------------------
#  export("clean")
#  clean <- function(dat) {
#    # ...
#  }
#  
#  export("recode")
#  recode <- function(dat) {
#    # ...
#  }
#  
#  helper <- function(...) {
#    # This function is private
#    # ...
#  }

## ----eval = FALSE-------------------------------------------------------------
#  import("ggplot2")
#  export("barplot", "lineplot")
#  
#  barplot <- function(dat) {
#    # ...
#  }
#  
#  lineplot <- function(dat) {
#    # ...
#  }
#  
#  helper <- function(...) {
#    # ...
#  }

## -----------------------------------------------------------------------------
module({
  fun <- function(x) {
    ## A function for illustrating documentation
    ## x (numeric) some values
    x
  }
})

