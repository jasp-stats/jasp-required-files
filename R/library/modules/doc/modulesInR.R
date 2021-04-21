## ---- results='asis', echo=FALSE----------------------------------------------
cat(gsub("\\n   ", "", packageDescription("modules", fields = "Description",encoding = NA)))

## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("modules")

## ---- eval=FALSE--------------------------------------------------------------
#  if (require("devtools")) install_github("wahani/modules")

## -----------------------------------------------------------------------------
library("modules")
m <- module({
  foo <- function() "foo"
})
m$foo()

## ----eval = FALSE-------------------------------------------------------------
#  m <- modules::use("module.R")
#  m$foo()

## ----error=TRUE---------------------------------------------------------------
x <- "hey"
m <- module({
  someFunction <- function() x
})
m$someFunction()
getSearchPathContent(m)

## -----------------------------------------------------------------------------
m <- module({
  functionWithDep <- function(x) stats::median(x)
})
m$functionWithDep(1:10)

## -----------------------------------------------------------------------------
m <- module({

  import("stats", "median") # make median from package stats available

  functionWithDep <- function(x) median(x)

})
m$functionWithDep(1:10)
getSearchPathContent(m)

## -----------------------------------------------------------------------------
m <- module({

  import("stats")

  functionWithDep <- function(x) median(x)

})
m$functionWithDep(1:10)

## -----------------------------------------------------------------------------
mm <- module({
  m <- use(m)
  anotherFunction <- function(x) m$functionWithDep(x)
})
mm$anotherFunction(1:10)

## ----eval = FALSE-------------------------------------------------------------
#  module({
#    m <- use("someFile.R")
#    # ...
#  })

## -----------------------------------------------------------------------------
m <- module({

  export("fun")

  fun <- identity # public
  privateFunction <- identity

  # .named are always private
  .privateFunction <- identity

})

m

## ----error=TRUE---------------------------------------------------------------
library("parallel")
dependency <- identity
fun <- function(x) dependency(x)

cl <- makeCluster(2)
clusterMap(cl, fun, 1:2)
stopCluster(cl)

## -----------------------------------------------------------------------------
m <- module({
  dependency <- identity
  fun <- function(x) dependency(x)
})

cl <- makeCluster(2)
clusterMap(cl, m$fun, 1:2)
stopCluster(cl)

