## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library("modules")
m <- module({
  foo <- function() "foo"
})
is.list(m)
class(m)

## -----------------------------------------------------------------------------
m <- module({

  import("stats", "median")

  anotherModule <- module({
    foo <- function() "foo"
  })
  
  bar <- function() "bar"

})

getSearchPathContent(m)
getSearchPathContent(m$anotherModule)

## -----------------------------------------------------------------------------
m <- function(param) {
  amodule({
    fun <- function() param
  })
}
m(1)$fun()

## -----------------------------------------------------------------------------

m <- function(param) {
  module(topEncl = environment(), {
    fun <- function() param
  })
}
m(1)$fun()

## -----------------------------------------------------------------------------
a <- module({
  foo <- function() "foo"
})

b <- module({
  a <- use(a)
  foo <- function() a$foo()
})

## -----------------------------------------------------------------------------
B <- function(a) {
  amodule({
    foo <- function() a$foo()
  })
}
b <- B(a)

## -----------------------------------------------------------------------------
mutableModule <- module({
  .num <- NULL
  get <- function() .num
  set <- function(val) .num <<- val
})
mutableModule$get()
mutableModule$set(2)

## -----------------------------------------------------------------------------
complectModule <- module({
  suppressMessages(use(mutableModule, attach = TRUE))
  getNum <- function() get()
  set(3)
})
mutableModule$get()
complectModule$getNum()

## -----------------------------------------------------------------------------
complectModule <- module({
  suppressMessages(use(mutableModule, attach = TRUE, reInit = FALSE))
  getNum <- function() get()
  set(3)
})
mutableModule$get()
complectModule$getNum()

## -----------------------------------------------------------------------------
A <- function() {
  amodule({
    foo <- function() "foo"
  })
}

B <- function(a) {
  amodule({
    expose(a)
    bar <- function() "bar"
  })
}

B(A())$foo()
B(A())$bar()

## -----------------------------------------------------------------------------
a <- module({
  foo <- function() "foo"
  bar <- function() "bar"
})

a

## -----------------------------------------------------------------------------
a <- module({
  foo <- function() "foo"
})

a <- extend(a, {
  bar <- function() "bar"
})

a

## -----------------------------------------------------------------------------
a <- module({
  foo <- function() "foo"
  test <- function() {
    stopifnot(foo() == "foo")
  }
})

## -----------------------------------------------------------------------------
a <- module({
  foo <- function() "foo"
})
extend(a, {
  stopifnot(foo() == "foo")
})

