### R code from vignette source 'hmeasure.Rnw'

###################################################
### code chunk number 1: hmeasure.Rnw:68-73
###################################################
require(MASS); require(class); data(Pima.te); 
library(hmeasure)
n <- dim(Pima.te)[1]; ntrain <- floor(2*n/3); ntest <- n-ntrain
pima.train <- Pima.te[seq(1,n,3),]
pima.test <- Pima.te[-seq(1,n,3),]


###################################################
### code chunk number 2: hmeasure.Rnw:76-78
###################################################
true.labels <- pima.test[,8]
str(true.labels)


###################################################
### code chunk number 3: hmeasure.Rnw:81-82
###################################################
lda.pima <- lda(formula=type~., data=pima.train)


###################################################
### code chunk number 4: hmeasure.Rnw:85-88
###################################################
out.lda = predict(lda.pima, newdata=pima.test)
true.labels.01 <- relabel(true.labels)
lda.labels.01 <- relabel(out.lda$class)


###################################################
### code chunk number 5: hmeasure.Rnw:91-92
###################################################
lda.counts <- misclassCounts(true.labels.01, lda.labels.01); lda.counts$conf.matrix


###################################################
### code chunk number 6: hmeasure.Rnw:95-96
###################################################
print(lda.counts$metrics,digits=3)


###################################################
### code chunk number 7: hmeasure.Rnw:107-108
###################################################
relabel(c("Yes","No","No"))


###################################################
### code chunk number 8: hmeasure.Rnw:111-112
###################################################
relabel(c("case","noncase","case"))


###################################################
### code chunk number 9: hmeasure.Rnw:133-134
###################################################
out.lda$posterior[1:3,]


###################################################
### code chunk number 10: hmeasure.Rnw:137-139
###################################################
scores.lda <- out.lda$posterior[,2]; 
all((scores.lda > 0.5) == lda.labels.01)


###################################################
### code chunk number 11: hmeasure.Rnw:142-145
###################################################
lda.counts.T03 <- misclassCounts(scores.lda>0.3, true.labels.01)
lda.counts.T03$conf.matrix
lda.counts.T03$metrics[c('Sens','Spec')]


###################################################
### code chunk number 12: hmeasure.Rnw:151-155
###################################################
class.knn <- knn(train=pima.train[,-8], test=pima.test[,-8],
  cl=pima.train$type, k=9, prob=TRUE, use.all=TRUE)
scores.knn <- attr(class.knn,"prob")
scores.knn[class.knn=="No"] <- 1-scores.knn[class.knn=="No"] 


###################################################
### code chunk number 13: hmeasure.Rnw:158-161
###################################################
scores <- data.frame(LDA=scores.lda,kNN=scores.knn)
results <- HMeasure(true.labels,scores)
class(results)


###################################################
### code chunk number 14: hmeasure.Rnw:171-172
###################################################
plotROC(results)


###################################################
### code chunk number 15: hmeasure.Rnw:181-182
###################################################
summary(results)


###################################################
### code chunk number 16: hmeasure.Rnw:198-199
###################################################
summary(results,show.all=TRUE)


###################################################
### code chunk number 17: hmeasure.Rnw:202-203
###################################################
HMeasure(true.labels,scores,threshold=0.3)$metrics[c('Sens','Spec')]


###################################################
### code chunk number 18: hmeasure.Rnw:206-207
###################################################
HMeasure(true.labels,scores,threshold=c(0.3,0.3))$metrics[c('Sens','Spec')]


###################################################
### code chunk number 19: hmeasure.Rnw:210-211
###################################################
HMeasure(true.labels,scores,threshold=c(0.5,0.3))$metrics[c('Sens','Spec')]


###################################################
### code chunk number 20: hmeasure.Rnw:216-217
###################################################
summary(HMeasure(true.labels,scores,level=c(0.95,0.99)))


###################################################
### code chunk number 21: hmeasure.Rnw:240-241
###################################################
plotROC(results,which=4)


###################################################
### code chunk number 22: hmeasure.Rnw:279-280
###################################################
results$metrics[c('H','KS','ER','FP','FN')]


###################################################
### code chunk number 23: hmeasure.Rnw:283-284
###################################################
summary(pima.test[,8])


###################################################
### code chunk number 24: hmeasure.Rnw:287-290
###################################################
results.SR1 <- HMeasure(
  true.labels, data.frame(LDA=scores.lda,kNN=scores.knn),severity.ratio=1)
results.SR1$metrics[c('H','KS','ER','FP','FN')]


###################################################
### code chunk number 25: hmeasure.Rnw:295-298
###################################################
par(mfrow=c(2,1))
plotROC(results,which=2)
plotROC(results.SR1,which=2)


###################################################
### code chunk number 26: hmeasure.Rnw:306-307
###################################################
plotROC(results,which=3)


