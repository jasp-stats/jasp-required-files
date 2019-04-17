## unit tests for variable key
## Ben Kite
## Charlie Redmon
## 20170801

## load packages
library(RUnit)
library(kutils)


## set data file paths (for package build)
dfPath <- system.file("extdata", "testDF.csv", package="kutils")
keyPath <- system.file("extdata", "testDF-key.csv", package="kutils")
widekeyPath <- system.file("extdata", "mydf.key.csv", package="kutils")
longkeyPath <- system.file("extdata", "mydf.key_long.csv", package="kutils")
widekeyXLSPath <- system.file("extdata", "mydf.key.xlsx", package="kutils")

## define precision level for float comparisons
floatPrecision <- 1e-6

## testing safeInteger() function:
##   1. Test safeInteger non-application (digits < tolerance)
##   2. Test safeInteger application (digits > tolerance)
test.safeInteger <- function() {
    checkIdentical(kutils::safeInteger(1.001), NULL)
    checkIdentical(kutils::safeInteger(1.0000000000001), 1L)
}

## testing assignMissing() function:
##   1. Test integers
##   2. Test characters
##   3. Test factors
##   4. Test ordered factors
##   5. Test numerics
test.assignMissing <- function() {

    ## CHECK INTEGERS
    x <- seq.int(-2L, 22L, by = 2L)

    ## specify specific values to drop
    x1 <- ifelse(x %in% c(8, 10, 18), NA, x)
    x2 <- assignMissing(x, "8;10;18")
    checkIdentical(x1, x2)

    ## specify range, inclusive
    x1 <- ifelse(x >= 4 & x <= 12, NA, x)
    x2 <- assignMissing(x, "[4,12]")
    checkIdentical(x1, x2)

    ## specify range, exclusive
    x1 <- ifelse(x > 4 & x < 12, NA, x)
    x2 <- assignMissing(x,  "(4,12)")
    checkIdentical(x1, x2)

    ## specify single inequality, exclusive
    x1 <- ifelse(x < 7, NA, x)
    x2 <- assignMissing(x, "< 7")
    checkIdentical(x1, x2)
    x1 <- ifelse(x > 11, NA, x)
    x2 <- assignMissing(x, "> 11")
    checkIdentical(x1, x2)

    ## specify single inequality, inclusive
    x1 <- ifelse(x <= 8, NA, x)
    x2 <- assignMissing(x, "<= 8")
    checkIdentical(x1, x2)

    ## specify multiple inequalities
    x1 <- ifelse(x < -1 | x==2 | x==4 | (x > 7 & x < 9) | x > 20, NA, x)
    x2 <- assignMissing(x, "< -1;2;4;(7, 9);> 20")
    checkIdentical(x1, x2)

    ## CHECK CHARACTERS
    x <- c("low", "low", "med", "high")

    ## specify multiple values to drop
    x1 <- ifelse(x %in% c("low", "high"), NA, x)
    x2 <- assignMissing(x, "low;high")
    checkIdentical(x1, x2)

    ## handling nonexistent values (possibly due to spelling mistakes)
    x1 <- ifelse(x %in% c("med","lo"), NA, x)
    x2 <- assignMissing(x, "med;lo")
    checkIdentical(x1, x2)
    
    ## test alternate separator
    x1 <- ifelse(x %in% c("low", "med"), NA, x)
    x2 <- assignMissing(x, "low|med", sep = "|")
    checkIdentical(x1, x2)

    ## CHECK FACTORS
    x <- factor(c("low", "low", "med", "high"), levels = c("low", "med", "high"))
    x1 <- x
    x1[x1 %in% c("low", "high")] <- NA
    x1 <- factor(x1)
    x2 <- assignMissing(x, "low;high")
    checkIdentical(x1, x2)

    ## CHECK ORDINAL FACTORS
    x <- ordered(c("low", "low", "med", "high"), levels = c("low", "med", "high"))
    x1 <- x
    x1[x1 %in% c("low", "high")] <- NA
    x1 <- factor(x1)
    x2 <- assignMissing(x, c("low", "high"))
    checkIdentical(x1, x2)

    ## CHECK NUMERICS
    set.seed(234234)
    x <- rnorm(10)

    ## test inequalities
    x1 <- ifelse(x < 0, NA, x)
    x2 <- assignMissing(x, "< 0")
    checkIdentical(x1, x2)
    x1 <- ifelse(x > -0.2, NA, x)
    x2 <- assignMissing(x, "> -0.2")
    checkIdentical(x1, x2)
    
    ## test ranges
    x1 <- ifelse(x > 0.1 & x < 0.7, NA, x)
    x2 <- assignMissing(x, "(0.1,0.7)")
    checkEqualsNumeric(x1, x2, tolerance=floatPrecision)
    x1 <- ifelse(x > -0.487971 & x < 0.143579, NA, x)
    x2 <- assignMissing(x, "(-0.487971, 0.143579)")
    checkEqualsNumeric(x1, x2, tolerance=floatPrecision)
}


## testing assignRecode() function:
##   1. check numeric transformations
test.assignRecode <- function() {

    set.seed(234234)
    x <- rpois(100, lambda = 3)
    x <- x[order(x)]

    ## log transformation
    xlog1 <- log(x + 1)
    xlog2 <- assignRecode(x, "log(x + 1)")
    checkEqualsNumeric(xlog1, xlog2, tolerance=floatPrecision)

    ## quadratic transformation
    xsq1 <- x^2
    xsq2 <- assignRecode(x, "x^2")
    checkEqualsNumeric(xsq1, xsq2, tolerance=floatPrecision)
    
    ## square root transformation
    xsqrt1 <- sqrt(x)
    xsqrt2 <- assignRecode(x, "sqrt(x)")
    checkEqualsNumeric(xsqrt1, xsqrt2, tolerance=floatPrecision)
    
}


## testing keyTemplate() function:
##   1. Test wide key
##   2. Test long key
##   3. Test sorting
test.keyTemplate <- function(){
    set.seed(234234)
    N <- 200
    mydf <- data.frame(x5 = rnorm(N),
                       x4 = rpois(N, lambda = 3),
                       x3 = ordered(sample(c("lo", "med", "hi"),
                                           size = N, replace=TRUE),
                                    levels = c("med", "lo", "hi")),
                       x2 = letters[sample(c(1:4,6), N, replace = TRUE)],
                       x1 = factor(sample(c("cindy", "bobby", "marcia",
                                            "greg", "peter"), N,
                                          replace = TRUE)),
                       x7 = ordered(letters[sample(c(1:4,6), N,
                                                   replace = TRUE)]),
                       x6 = sample(c(1:5), N, replace = TRUE),
                       stringsAsFactors = FALSE)
    mydf$x4[sample(1:N, 10)] <- 999
    mydf$x5[sample(1:N, 10)] <- -999

    ## test basic keyTemplate functionality
    kt <- keyTemplate(mydf)
    checkEquals(kt$class_old, kt$class_new, c("numeric", "integer", "ordered",
                                              "character", "factor", "ordered",
                                              "integer"))
    checkEquals(kt$value_old, kt$value_new, c("", "0|1|2|3|4|5|6|7|11|999",
                                              "med<lo<hi", "a|b|c|d|f",
                                              "bobby|cindy|greg|marcia|peter",
                                              "a<b<c<d<f", "1|2|3|4|5"))

    ## test long key
    ktL <- keyTemplate(mydf, long=TRUE)
    checkEquals(nrow(ktL[ktL$name_old=="x3",]), 4)
    checkEquals(unique(ktL$class_old), unique(kt$class_old))

    ## test key sorting
    ktS <- keyTemplate(mydf, sort=TRUE)
    checkEquals(ktS$name_old, paste0("x", 1:7))
    ktSvals <- unique(ktS$value_old)
    ktVals <- unique(kt$value_old)
    checkEquals(ktSvals[order(ktSvals)], ktVals[order(ktVals)])

}

## testing keyImport() function:
##   1. check that direct import produces same result as data.frame import
##   (all other parameters handled by separate functions)
test.keyImport <- function() {
    ## check wide key direct import and import from read-in data
    widekey1 <- keyImport(widekeyPath, long=FALSE)
    widekeyDF <- read.csv(widekeyPath, stringsAsFactors=FALSE)
    widekey2 <- keyImport(widekeyDF, long=FALSE)
    attr(widekey1, "varlab") <- NULL
    attr(widekey2, "varlab") <- NULL
    checkEquals(widekey1, widekey2)

    ## check long key import
    longkey1 <- keyImport(longkeyPath, long=TRUE)
    longkeyDF <- read.csv(longkeyPath, stringsAsFactors=FALSE)
    longkey2 <- keyImport(longkeyDF, long=TRUE)
    attr(longkey1, "varlab") <- NULL
    attr(longkey2, "varlab") <- NULL
    checkEquals(longkey1, longkey2)

}


## test keyApply function
test.keyApply <- function() {

    df0 <- read.csv(dfPath, stringsAsFactors=TRUE)
    key <- keyImport(keyPath)
    df1 <- keyApply(df0, key, diagnostic = FALSE)

    ## TEST CONVERSIONS FROM LOGICAL
    l <- df0[ ,"varL"]
    
    ## logical --> logical
    ll0 <- ifelse(l == FALSE, TRUE, FALSE)
    checkIdentical(ll0, df1[,"varLL"])  #compare code version with VarKey version

    ## logical --> integer (1)
    ## li0 <- as.integer(l)
    ## checkIdentical(li0, df1[,"varLI1"])

    ## logical --> integer (2)
    li0 <- as.integer(ifelse(l == FALSE, 0, 1))
    checkIdentical(li0, df1[,"varLI2"])

    ## logical --> numeric (1)
    ## ln0 <- as.numeric(l)
    ## checkEqualsNumeric(ln0, df1[,"varLN1"], tolerance=floatPrecision)
    
    ## logical --> numeric (2)
    ln0 <- ifelse(l == FALSE, -0.5, 0.5)
    checkEqualsNumeric(ln0, df1[,"varLN2"], tolerance=floatPrecision)

    ## logical --> factor (1)
    ## lf0 <- factor(l)
    ## checkIdentical(lf0, df1[,"varLF1"])
    
    ## logical --> factor (2)
    lf0 <- factor(ifelse(l == FALSE, "no", "yes"), levels=c("yes","no"))
    checkIdentical(lf0, df1[,"varLF2"])

    ## logical --> ordinal (1)
    ## lo0 <- ordered(l)
    ## checkIdentical(lo0, df1[,"varLO1"])
    
    ## logical --> ordinal (2)
    lo0 <- ordered(ifelse(l == FALSE, "fail", "pass"))
    checkIdentical(lo0, df1[,"varLO2"])

    ## logical --> character (1)
    lc0 <- as.character(l)
    checkIdentical(lc0, df1[,"varLC1"])

    ## logical --> character (2)
    lc0 <- as.character(ifelse(l == FALSE, "A", "B"))
    checkIdentical(lc0, df1[,"varLC2"])

    ## TEST CONVERSIONS FROM INTEGER
    i1 <- df0[,"varI1"]
    i2 <- df0[,"varI2"]
    
    ## integer --> logical (1)
    ## il0 <- as.logical(ifelse(i1 >= 999, NA, i1))
    ## checkIdentical(il0, df1[,"varIL1"])

    ## integer --> logical (2)
    il0 <- as.logical(ifelse(i2 == 1, TRUE, FALSE))
    checkIdentical(il0, df1[,"varIL2"])
    
    ## integer --> integer
    ii0 <- ifelse(i1 >= 999, NA, i1)
    checkIdentical(ii0, df1[,"varII"])

    ## integer --> numeric (1)
    in0 <- as.numeric(ifelse(i1 >= 999, NA, i1))
    checkEqualsNumeric(in0, df1[,"varIN1"], tolerance=floatPrecision)
 
    ## integer --> numeric (2)
    in0 <- as.numeric(plyr::mapvalues(i2, from=1:5, to=seq(1, 3, by=0.5)))
    checkEqualsNumeric(in0, df1[,"varIN2"], tolerance=floatPrecision)

    ## integer --> factor (1)
    if0 <- factor(i2)
    checkIdentical(if0, df1[,"varIF1"])
    
    ## integer --> factor (2)
    if0 <- factor(ifelse(i2 < 3, "nonHOV", "HOV"), levels=c("nonHOV","HOV"))
    checkIdentical(if0, df1[,"varIF2"])

    ## integer --> ordinal (1)
    io0 <- ordered(i2)
    checkIdentical(io0, df1[,"varIO1"])
    
    ## integer --> ordinal (2)
    io0 <- ordered(plyr::mapvalues(i2, from=1:5,
                   to=c("unfavorable", "slightlyUnfavorable", "neutral",
                        "slightlyFavorable", "favorable")),
                   levels=c("unfavorable", "slightlyUnfavorable", "neutral",
                            "slightlyFavorable", "favorable"))
    checkIdentical(io0, df1[,"varIO2"])

    ## integer --> character (1)
    ic0 <- as.character(ifelse(i1 >= 999, NA, i1))
    checkIdentical(ic0, df1[,"varIC1"])
    
    ## integer --> character (2)
    ic0 <- as.character(plyr::mapvalues(i2, from=1:5,
                                        to=c("a", "b", "c", "d", "f")))
    checkIdentical(ic0, df1[,"varIC2"])
    
    ## TEST CONVERSIONS FROM NUMERIC
    n1 <- df0[,"varN1"]
    n2 <- df0[,"varN2"]

    ## numeric --> logical (2)
    ## nl0 <- as.logical(n2)
    ## checkIdentical(nl0, df1[,"varNL1"])
    
    ## numeric --> logical (2)
    nl0 <- ifelse(n2 < 0.5, FALSE, TRUE)
    checkIdentical(nl0, df1[,"varNL2"])

    ## numeric --> integer (1)
    ni0 <- as.integer(n2)
    checkEquals(ni0, df1[,"varNI1"])
    
    ## numeric --> integer (2)
    ni0 <- as.integer(ifelse(n2 < 0.5, 0, 1))
    checkEquals(ni0, df1[,"varNI2"])

    ## numeric --> numeric
    nn0 <- ifelse(n1 <= -999, NA, n1)
    checkEqualsNumeric(nn0, df1[,"varNN"], tolerance=floatPrecision)

    ## numeric --> factor (1)
    nf0 <- factor(n2)
    checkIdentical(nf0, df1[,"varNF1"])
    
    ## numeric --> factor (2)
    nf0 <- factor(plyr::mapvalues(as.character(n2),
                  from=as.character(seq(0, 1, 0.1)),
                  to=c(rep("Q1", 3), rep(paste0("Q",2:5), each=2))))
    checkIdentical(nf0, df1[,"varNF2"])
    
    ## numeric --> ordinal (1)
    no1 <- ordered(n2)
    checkIdentical(no1, df1[,"varNO1"])

    ## numeric --> ordinal (2)
    no1 <- ordered(plyr::mapvalues(as.character(n2),
                   from=as.character(seq(0, 1, 0.1)),
                   to=c(rep("lower",5), rep("middle",4), rep("upper",2))))
    checkIdentical(no1, df1[,"varNO2"])
    
    ## numeric --> character (1)
    nc0 <- as.character(ifelse(n1 <= -999, NA, n1))
    checkIdentical(nc0, df1[,"varNC1"])

    ## numeric --> character (2)
    nc0 <- plyr::mapvalues(as.character(n2), from=as.character(seq(0, 1, 0.1)),
                           to=c("A","B","C","D","E","F","G","H","I","J","K"))
    checkIdentical(nc0, df1[,"varNC2"])

    ## TEST CONVERSIONS FROM FACTOR
    f1 <- df0[,"varF1"]
    f2 <- df0[,"varF2"]
    f3 <- df0[,"varF3"]
    f4 <- df0[,"varF4"]

    ## factor --> logical (1)
    ## fl0 <- as.logical(f1)
    ## checkIdentical(fl0, df1[,"varFL1"])
    
    ## factor --> logical (2)
    ## fl0 <- ifelse(f1 == "yes", TRUE, FALSE)
    ## checkIdentical(fl0, df1[,"varFL2"])

    ## factor --> integer (1)
    ## fi0 <- as.integer(f1)
    ## checkIdentical(fi0, df1[,"varFI1"])
    
    ## factor --> integer (2)
    fi0 <- as.integer(ifelse(f1 == "yes", 1, 0))
    checkIdentical(fi0, df1[,"varFI2"])

    ## factor --> numeric (1)
    ## fn0 <- as.numeric(f2)
    ## checkEqualsNumeric(fn0, df1[,"varFN1"], tolerance=floatPrecision)
    
    ## factor --> numeric (2)
    fn0 <- as.numeric(as.character(plyr::mapvalues(f2,
                                                   from=c("lo", "med", "hi"),
                                                   to=c(-0.5, 0, 0.5))))
    checkEqualsNumeric(fn0, df1[,"varFN2"], tolerance=floatPrecision)

    ## factor --> factor
    ff0 <- plyr::mapvalues(f3, from=levels(f3), to=c(rep("P", 4), "F"))
    checkEquals(ff0, df1[,"varFF"])

    ## factor --> ordinal (2)
    fo0 <- ordered(f2)
    checkIdentical(fo0, df1[,"varFO1"])

    ## factor --> ordinal (2)
    fo0 <- ordered(plyr::mapvalues(f2,
                   from=levels(f2), to=c("high", "low", "mid")),
                   levels=c("low","mid","high"))
    checkIdentical(fo0, df1[,"varFO2"])

    ## factor --> character (1)
    fc0 <- as.character(f4)
    checkIdentical(fc0, df1[,"varFC1"])

    
    ## factor --> character (2)
    fc0 <- as.character(plyr::mapvalues(f4, from=levels(f4),
                        to=c("Bobby","Cindy","Greg","Marcia","Peter")))
    checkIdentical(fc0, df1[,"varFC2"])

    ## TEST CONVERSIONS FROM ORDINAL
    o <- df0[,"varO1"]

    ## ordinal --> logical (1)
    ## ol0 <- as.logical(o)
    ## checkIdentical(ol0, df1[,"varOL1"])
    
    ## ordinal --> logical (2)
    ol0 <- ifelse(o == "1", FALSE, TRUE)
    checkIdentical(ol0, df1[,"varOL2"])

    ## ordinal --> integer (1)
    ## oi0 <- as.integer(o)
    ## checkIdentical(oi0, df1[,"varOI1"])
    
    ## ordinal --> integer (2)
    oi0 <- as.integer(as.character(o))
    checkIdentical(oi0, df1[,"varOI2"])

    ## ordinal --> numeric (1)
    ## on0 <- as.numeric(o)
    ## checkEqualsNumeric(on0, df1[,"varON1"], tolerance=floatPrecision)
    
    ## ordinal --> numeric (2)
    on0 <- as.numeric(as.character(o))
    checkEqualsNumeric(on0, df1[,"varON2"], tolerance=floatPrecision)

    ## ordinal --> factor (1)
    ## of0 <- factor(o, ordered=FALSE)
    ## checkIdentical(of0, df1[,"varOF1"])
    
    ## ordinal --> factor (2)
    of0 <- factor(plyr::mapvalues(o, c(1,3,5), c("A","B","C")), ordered=FALSE)
    checkIdentical(of0, df1[,"varOF2"])

    ## ordinal --> ordinal
    ## of0 <- plyr::mapvalues(o, from=c(1,3,5), to=c("low","mid","high"))
    ## checkIdentical(of0, df1[,"varOO"])

    ## ordinal --> character (1)
    ## oc0 <- as.character(o)
    ## checkIdentical(oc0, df1[,"varOC1"])
    
    ## ordinal --> character (2)
    oc0 <- as.character(plyr::mapvalues(o, from=c("1","3","5"),
                                        to=c("1","5","7")))
    checkIdentical(oc0, df1[,"varOC2"])

    ## TEST CONVERSIONS FROM CHARACTER
    c1 <- df0[,"varC1"]

    ## character --> logical (1)
    ## cl0 <- as.logical(c1)
    ## checkIdentical(cl0, df1[,"varCL1"])
    
    ## character --> logical (2)
    cl0 <- ifelse(c1 %in% c("0","0.1","0.2","0.3","0.4"), FALSE, TRUE)
    checkIdentical(cl0, df1[,"varCL2"])

    ## character --> integer (1)
    ## ci0 <- as.integer(c1)
    ## checkIdentical(ci0, df1[,"varCI1"])
    
    ## character --> integer (2)
    ci0 <- as.integer(ifelse(c1 %in% c("0","0.1","0.2","0.3","0.4"), 0, 1))
    checkIdentical(ci0, df1[,"varCI2"])

    ## character --> numeric (1)
    ## cn0 <- as.numeric(c1)
    ## checkEqualsNumeric(cn0, df1[,"varCN1"], tolerance=floatPrecision)
    
    ## character --> numeric (2)
    ## PJ What is problem with this one? I saved data onto data set
    ## cn0 <- as.numeric(plyr::mapvalues(c1, from=seq(0, 1, 0.1),
    ##                                   to=seq(-0.5, 0.5, 0.1),
    ##                                   warn_missing = TRUE))
    ## checkEqualsNumeric(cn0, df1[,"varCN2"], tolerance=floatPrecision)

    ## character --> factor (1)
    ## cf0 <- factor(c1)
    ## checkIdentical(cf0, df1[,"varCF1"])
    
    ## character --> factor (2)
    cf0 <- factor(plyr::mapvalues(c1, from=as.character(seq(0,1,0.1)),
                  to=c("X","X","X","X","Y","Y","Y","Y","Z","Z","Z")))
    checkIdentical(cf0, df1[,"varCF2"])

    ## character --> ordinal (1)
    ## co0 <- ordered(c1)
    ## checkIdentical(co0, df1[,"varCO1"])
        
    ## character --> ordinal (2) 
    co0 <- ordered(plyr::mapvalues(c1, from=as.character(seq(0,1,0.1)),
                   to=c("F","F","F","F","F","F","D","C","B","A","A")),
                   levels=c("F","D","C","B","A"))
    checkIdentical(co0, df1[,"varCO2"])

    ## character --> character
    cc0 <- plyr::mapvalues(c1, from=as.character(seq(0,1,0.1)),
                           to=letters[seq(1, 11)])
    checkIdentical(cc0, df1[,"varCC"])
}


## test wide2long() function
test.wide2long <- function() {
    ## confirm round-trip
    wkey <- keyImport(widekeyPath, long=FALSE)
    wkeylong <- wide2long(wkey)
    checkEquals(wkey, long2wide(wkeylong))
    ## Import supposedly equivalent long key
    lkey0 <- keyImport(longkeyPath, long=TRUE)
    lkey1 <- wide2long(wkey)
    ## Ignore differences in attributes
    rownames(lkey0) <- NULL
    attr(lkey0, "ignoreCase") <- NULL
    attr(lkey0, "varlab") <- NULL
    rownames(lkey1) <- NULL
    attr(lkey1, "ignoreCase") <- NULL
    attr(lkey1, "varlab") <- NULL
    checkEquals(lkey0, lkey1)
}


## test long2wide() function
test.long2wide <- function() {
    ## confirm round trip
    keylong <- keyImport(longkeyPath, long=TRUE)
    keylong2wide <- long2wide(keylong)
    checkEquals(keylong, wide2long(keylong2wide))
    ## Import supposedly equivalent wide key
    wkey0 <- keyImport(widekeyPath, long=FALSE)
    ## Confirm wkey0 equivalent to keylongwide
    checkEquals(wkey0, keylong2wide)
    ## confirm can convert long2wide output
    row.names(wkey0) <- NULL
    attr(wkey0, "ignoreCase") <- NULL
    row.names(keylong2wide) <- NULL
    attr(wkey0, "varlab") <- NULL
    attr(keylong2wide, "varlab") <- NULL
    checkEquals(wkey0, keylong2wide)
}


## test keyUpdate() function:
##   1. Add new variables to data frame
##   2. Modify existing entries in data frame
##   3. Preserve name_new and class_new in updated key
test.keyUpdate <- function() {
    ## check long key
    set.seed(1233)
    dat1 <- data.frame(Score = c(1, 2, 3, 42, 4, 2),
                       Gender = c("M", "M", NA, "F", "F", "F"))
    ##   setting up key
    key1 <- keyTemplate(dat1, long=TRUE)
    key1[5, "value_new"] <- 10
    key1[7, "value_new"] <- "female"
    key1[8, "value_new"] <- "male"
    ##   modifying data
    dat2 <- data.frame(Score = c(7, 13, NA),
                       Gender = c("other", NA, "F"),
                       Weight = rnorm(3))
    dat2 <- plyr::rbind.fill(dat1, dat2)
    ##   update key
    key2 <- keyUpdate(key1, dat2, append=FALSE)
    ## difference should be 
    alteredrows <-
        structure(list(name_old = c("Gender", "Score", "Score", "Weight"
), name_new = c("Gender", "Score", "Score", "Weight"), class_old = c("factor", 
"integer", "integer", "numeric"), class_new = c("factor", "integer", 
"integer", "numeric"), value_old = c("other", "7", "13", "."), 
    value_new = c("other", "7", "13", "."), missings = c("", 
    "", "", ""), recodes = c("", "", "", "")), .Names = c("name_old", 
"name_new", "class_old", "class_new", "value_old", "value_new", 
"missings", "recodes"), row.names = c("3.new", "10.new", "11.new", 
"13.new"), class = c("keylong", "data.frame"))
    checkEquals(keyDiff(key1, key2)[[2]], alteredrows)

    ## check wide key
    key1 <- keyTemplate(dat1)
    key2 <- keyUpdate(key1, dat2)
    keydelta <- keyDiff(key1, key2)
    checkEquals(2, NROW(keydelta[[1]]))
    checkEquals(3, NROW(keydelta[[2]]))
    neworaltered <- structure(list(name_old = c("Score", "Gender", "Weight"), name_new = c("Score", 
"Gender", "Weight"), class_old = c("integer", "factor", "numeric"
), class_new = c("integer", "factor", "numeric"), value_old = c("1|2|3|4|42|7|13|.", 
"F|M|other|.", "."), value_new = c("1|2|3|4|42|7|13|.", "F|M|other|.", 
"."), missings = c("", "", ""), recodes = c("", "", "")), .Names = c("name_old", 
"name_new", "class_old", "class_new", "value_old", "value_new", 
"missings", "recodes"), row.names = c("Score.new", "Gender.new", 
"Weight.new"), class = c("key", "data.frame"))
     checkEquals(neworaltered, keydelta[[2]])
        
    ## check name preservation
    key1$name_new <- c("ScoreVar", "GenderVar")
    key2 <- keyUpdate(key1, dat2)
    ## Check that all name_new from key1 are still present in key2
    checkEquals(all(key1[ , "name_new"] %in% key2[ , "name_new"]), TRUE)
}


## ## test keyDiff() function
## ## test.keyDiff <- function() {
## ##     ## check that keyUpdate changes are reflected in keyDiff
## ##     dat1 <- data.frame(Score = c(1, 2, 3, 42, 4, 2),
## ##                        Gender = c("M", "M", "M", "F", "F", "F"))
## ##     key1 <- keyTemplate(dat1, long = TRUE)
## ##     key1[5, "value_new"] <- 10
## ##     key1[6, "value_new"] <- "female"
## ##     key1[7, "value_new"] <- "male"
## ##     key1[key1$name_old=="Score", "name_new"] <- "ScoreVar"
## ##     dat2 <- data.frame(Score = 7, Gender = "other", Weight = rnorm(3))
## ##     dat2 <- plyr::rbind.fill(dat1, dat2)
## ##     key2 <- keyUpdate(key1, dat2, append=FALSE)
## ##     diffOutput1 <- keyDiff2(key1, key2)
## ##     checkEquals(grepl("Gender", diffOutput1), TRUE)
## ##     checkEquals(grepl("ScoreVar", diffOutput1), FALSE)

## ##     ## check identity condition
## ##     diffOutput2 <- keyDiff(key1, key1)
## ##     checkEquals(grepl("no differences", diffOutput2), TRUE)
    
## ## }


## test keyRead() function:
##   1. xlsx and csv imports should be equivalent
test.keyRead <- function() {
    key1 <- kutils:::keyRead(widekeyPath)
    key2 <- kutils:::keyRead(widekeyXLSPath)
    attr(key1, "varlab") <- NULL
    attr(key2, "varlab") <- NULL
    checkEquals(key1, key2)
}


## test keyPool() function:
##   1. Legal conversions (on both or a single class column)
##   2. Non-legal conversions result in warning
test.keysPool <- function() {
    ## setup
    set.seed(1234)
    dat1 <- data.frame(x1 = as.integer(rnorm(100)),
                       x2 = sample(c("Apple", "Orange"), 100, replace = TRUE),
                       x3 = ifelse(rnorm(100) < 0, TRUE, FALSE))
    dat2 <- data.frame(x1 = rnorm(100),
                       x2 = ordered(sample(c("Apple","Orange"),100,replace=TRUE)),
                       x3 = rbinom(100, 1, .5),
                       stringsAsFactors = FALSE)
    key1 <- keyTemplate(dat1, long=TRUE)
    key2 <- keyTemplate(dat2, long=TRUE)
    stackedKeys <- rbind(key1, key2)

    ## check default usage with promotable classes
    stackedKeysFix <- kutils:::keysPool(stackedKeys)
    checkEquals(stackedKeysFix$class_old,
                stackedKeysFix$class_new,
                c(rep("numeric", 4), rep("factor", 3), rep("numeric", 5)))

    ## check case where to homogenization is not possible
    set.seed(123456)

    key3 <- structure(list(
        name_old = c("x1", "x1", "x1", "x1", "x1", "x1",
                     "x2", "x2", "x2"),
        name_new = c("x1", "x1", "x1", "x1", "x1",
                     "x1", "x2", "x2", "x2"),
        class_old = c("integer", "integer",
                      "integer", "integer", "integer", "integer", "factor", "factor",
                      "factor"),
        class_new = c("integer", "integer", "integer", "integer",
                      "integer", "integer", "factor", "factor", "factor"),
        value_old = c("-2", "-1", "0", "1", "2", ".", "Apple", "Orange", "."),
        value_new = c("-2","-1", "0", "1", "2", ".", "Apple", "Orange", "."),
        missings = c("","", "", "", "", "", "", "", ""),
        recodes = c("", "", "", "",
                    "", "", "", "", "")),
        row.names = c(NA, -9L), class = c("keylong",
                                          "data.frame"), missSymbol = ".")

    key4 <- structure(list(
        name_old = c("x1", "x2", "x2", "x2"), name_new = c("x1",
                                                           "x2", "x2", "x2"),
        class_old = c("numeric", "character", "character",
                      "character"),
        class_new = c("numeric", "character", "character",
                      "character"),
        value_old = c(".", "Apple", "Orange", "."),
        value_new = c(".", "Apple", "Orange", "."),
        missings = c("", "", "", ""),
        recodes = c("", "", "", "")),
        row.names = c(NA, -4L), class = c("keylong", "data.frame"),
        missSymbol = ".")
    stackedKeys2 <- rbind(key3, key4)
    stackedKeys2Fix <- keysPool(stackedKeys2)

    stackedKeys2Fix.saved <-
        structure(list(name_old = c("x1", "x1", "x1", "x1", "x1", "x1", 
                                    "x2", "x2", "x2"), name_new = c("x1", "x1", "x1", "x1", "x1", 
                                                                    "x1", "x2", "x2", "x2"),
                       class_old = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "character", "character", 
                                     "character"), class_new = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                                                 "character", "character", "character"),
                       value_old = c("-2", "-1", "0", "1", "2", ".", "Apple", "Orange",  "."),
                       value_new = c("-2", "-1", "0", "1", "2", ".", "Apple", "Orange", "."),
                       missings = c("", "", "", "", "", "", "", "", ""),
                       recodes = c("", "", "", "", "", "", "", "", "")),
                  missSymbol = ".", row.names = c("x1.1", "x1.2", "x1.3", "x1.4", "x1.5", "x1.6", "x2.7", "x2.8", "x2.9"),
                  class = c("keylong", "data.frame"))
    stack.diff <-  keyDiff(stackedKeys2Fix, stackedKeys2Fix.saved)
    saveRDS(stack.diff, file = "stack.diff.rds")
    saveRDS(key3, file = "key3.rds")
    saveRDS(key4, file = "key4.rds")
    saveRDS(stackedKeys2Fix, file = "stackedKeys2Fix.rds")
    saveRDS(stackedKeys2Fix.saved, file = "stackedKeys2Fix.saved.rds")
    checkEquals(stack.diff, NULL)
}


## ## test keyCrossRef() function
## test.keyCrossRef <- function() {
##     ## set up key
##     dat <- data.frame(x1 = sample(c("a", "b", "c", "d"), 100, replace = TRUE),
##                      x2 = sample(c("Apple", "Orange"), 100, replace = TRUE),
##                      x3 = ordered(sample(c("low", "medium", "high"), 100, replace = TRUE),
##                                   levels = c("low", "medium", "high")),
##                      stringsAsFactors = FALSE)
##     key1 <- keyTemplate(dat, long = TRUE)
    
##     ## with a fresh key no flags should be produced
##     crossref1 <- tryCatch(kutils:::keyCrossRef(key1, verbose = TRUE),
##                           warning = function(w) w)
##     checkTrue(!("warning" %in% class(crossref1)))

##     ## modify key and check for flags
##     key2 <- key1
##     key2[1:2, "value_new"] <- c("b", "a")
##     key2[7:9, "value_new"] <- c("high", "medium", "low")
##     crossref2 <- tryCatch(kutils:::keyCrossRef(key2, verbose=TRUE),
##                           warning = function(w) w)
##     checkTrue("warning" %in% class(crossref2))
    
## }
