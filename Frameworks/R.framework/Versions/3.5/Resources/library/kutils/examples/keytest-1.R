library(kutils)

mydf.path <-  system.file("extdata", "mydf.csv", package = "kutils")
mydf.key.path <-  system.file("extdata", "mydf.key_new.csv", package = "kutils")
mydf.keylong.path <- system.file("extdata", "mydfkey.long_new.csv", package = "kutils")

mydf.keylist1 <- keyImport(mydf.key.path)

mydf.key <- read.csv(mydf.key.path, stringsAsFactors = FALSE)
mydf.keylist2 <- keyImport(mydf.key, long = FALSE)

identical(mydf.keylist1, mydf.keylist2)


dframe <- read.csv(mydf.path, stringsAsFactors = FALSE)

keyApply(dframe, mydf.keylist1)



klistlong1 <- keyImport(mydf.keylong.path, long = TRUE)

keylong2 <- read.csv(mydf.keylong.path, stringsAsFactors = FALSE)
klistlong2 <- keyImport(keylong2, long = TRUE)


identical(klistlong1, klistlong2)


dfnew <- keyApply(dframe = dframe, keylist = klistlong2)

dfnew2 <- keyApply(dframe = dframe, keylist = klistlong2, diagnostic = TRUE)


debug(keyApply)
