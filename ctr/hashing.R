# train.log <- read.delim("~/Documents/Python/make-ipinyou-data/1458/train.log.txt")
# test.log <- read.delim("~/Documents/Python/make-ipinyou-data/1458/test.log.txt")

# ratio <- 1

# ipinyou.train <- train.log[sort(sample(1:nrow(train.log), as.integer(nrow(train.log)*ratio), replace=FALSE)),]
# rm(train.log)
# ipinyou.test <- test.log[sort(sample(1:nrow(test.log), as.integer(nrow(test.log)*ratio), replace=FALSE)),]
# rm(test.log)

ipinyou.train <- read.delim("~/Documents/Python/make-ipinyou-data/3386/train.log.txt")
ipinyou.test <- read.delim("~/Documents/Python/make-ipinyou-data/3386/test.log.txt")

library(FeatureHashing)
library(Matrix)
library(parallel)
library(foreach)
library(glmnet)
library(xgboost)
library(Metrics)
library(pROC)

f <- ~ weekday + hour + timestamp + useragent + IP + region + 
  city + adexchange + domain + slotid + slotwidth + slotheight +
  slotvisibility + slotformat + slotprice + creative + advertiser +
  split(usertag, delim = ",")

m.train <- hashed.model.matrix(f, ipinyou.train, 2^20)
m.test <- hashed.model.matrix(f, ipinyou.test, 2^20)
cv.g.gdbt <- xgboost(m.train, ipinyou.train$click, max.depth=7, eta=0.1, nround = 500, objective = "binary:logistic", verbose = ifelse(interactive(), 1, 0))
p.lm <- predict(cv.g.gdbt, m.test)
glmnet::auc(ipinyou.test$click, p.lm)
logLoss(ipinyou.test$click, p.lm)
rocobj <- roc(ipinyou.test$click, p.lm)
plot.roc(rocobj, col="blue")

# source(system.file("ftprl.R", package = "FeatureHashing"))
# m.train <- hashed.model.matrix(f, ipinyou.train, 2^20, transpose = TRUE)
# ftprl <- initialize.ftprl(0.1, 1, 0.1, 0.1, 2^20)
# ftprl <- update.ftprl(ftprl, m.train, ipinyou.train$click, predict = TRUE)
# glmnet::auc(ipinyou.train$click, attr(ftprl, "predict"))

# cv.g.lr <- cv.glmnet(m.train, ipinyou.train$click, family = "binomial")
# p.lr <- predict(cv.g.lr, m.test, s="lambda.min")
# glmnet::auc(ipinyou.test$click, p.lr)

