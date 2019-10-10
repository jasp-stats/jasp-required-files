library(kutils)
mydf.key.path <- system.file("extdata", "mydf.key.csv", package = "kutils")
mydf.key <-  keyImport(mydf.key.path)
mydf.path <- system.file("extdata", "mydf.csv", package = "kutils")

## Use if testing new functions in R code
## assignInNamespace("makeKeylist", kutils:::makeKeylist, "kutils")
## assignInNamespace("keyApply", keyApply, "kutils")

mydf <- read.csv(mydf.path, stringsAsFactors = FALSE)

## insert variable not in key
mydf$g1 <- 2 * mydf$x6
mydf2a <- keyApply(mydf, mydf.key, drop = FALSE)
mydf2b <- keyApply(mydf, mydf.key, drop = TRUE)

## erase some value_new in key
mydf.key.long <- wide2long(mydf.key)
mydf.key.long2 <- mydf.key.long
mydf.key.long2["x1.x1.3", "value_new"] <- "."
mydf.key.2 <- long2wide(mydf.key.long2)

mydf3a.wide <- keyApply(mydf, mydf.key.2, drop = FALSE)
mydf3b.wide <- keyApply(mydf, mydf.key.2, drop = TRUE)
## Should be equal, except for presence of column g1 in mydf3a.long
for(jj in colnames(mydf3b.long)) print(all.equal(mydf3a.wide[ , jj], mydf3b.wide[ , jj]))

mydf3a.long <- keyApply(mydf, mydf.key.long, drop = FALSE)
mydf3b.long <- keyApply(mydf, mydf.key.long, drop = TRUE)
## Should be equal, except for presence of column g1 in mydf3a.long
for(jj in colnames(mydf3b.long)) print(all.equal(mydf3a.long[ , jj], mydf3b.long[ , jj]))
all.equal(mydf3a.long, mydf3a.wide)
all.equal(mydf3b.long, mydf3b.wide)

## Now omit that value from both value_new and value_old
mydf.key.long.3 <- mydf.key.long[-match("x1.x1.3", rownames(mydf.key.long)), ]
mydf.key.3 <- long2wide(mydf.key.long.3)

mydf3a <- keyApply(mydf, mydf.key, drop = FALSE)
mydf3b <- keyApply(mydf, mydf.key, drop = TRUE)


## erase same line from key


## Creates more transformations
mydf.key.3 <-  keyImport("mydf2.csv")
mydf3 <- keyApply(mydf, mydf.key.3, drop = FALSE)
mydf3 <- keyApply(mydf, mydf.key.3, drop = c("vals"))

## Re-read data, 
mydf$x1 <- factor(mydf$x1)

mydf3 <- keyApply(mydf, mydf2.key, drop = FALSE)

mydf3 <- keyApply(mydf, mydf2.key, drop = TRUE)
mydf3 <- keyApply(mydf, mydf2.key, drop = "vars")
mydf3 <- keyApply(mydf, mydf2.key, drop = "vals")
## Should fail:
mydf3 <- keyApply(mydf, mydf2.key, drop = "typo")
