rm(list=ls())
setwd("~/Desktop/section9")
### SUPER LEARNER ###
if (!require(rpart)) install.packages("rpart"); library(rpart)
if (!require(dplyr)) install.packages("dplyr"); library(dplyr)
if (!require(SuperLearner)) install.packages("SuperLearner"); library(SuperLearner)
if (!require(haven)) install.packages("haven"); library(haven)
if (!require(ranger)) install.packages("ranger"); library(ranger)
if (!require(randomForest)) install.packages("randomForest"); library(randomForest)
if (!require(gam)) install.packages("gam"); library(gam)
if (!require(glmnet)) install.packages("glmnet"); library(gam)
if (!require(earth)) install.packages("earth"); library(earth)
if (!require(nnet)) install.packages("nnet"); library(nnet)
if (!require(gbm)) install.packages("gbm"); library(gbm)
if (!require(arm)) install.packages("arm"); library(arm)


project4 <- read_dta("project4.dta")
View(project4)

#### Easy Implementation of the Super Learner ####
#The super chooses the optimal weighted combination of algorithms that minimizes a cross validated loss function#
#See Rose (2013) "Mortality risk score prediction in an elderly population using machine learning."
#for a thorough and relatively non-technical review
#install.packages("SuperLearner")#

project4_train <- project4 %>%
  filter(training==1)

project4_test <- project4 %>%
  filter(training==0)

vars <- colnames(project4[10:ncol(project4)])

Y.train <- project4_train$kfr_pooled_p25
X.train <- subset(project4_train, select=vars)
X <- subset(project4, select=vars)


#think about the algorithms you would like to include in your library#
#the super learner package has many choices built in# use listWrappers() to see all possible algorithms
#Here is an example library#
SL.library <- list(c("SL.randomForest", "screen.glmnet"), "SL.glm", "SL.rpart")

##Now we can create a super learner function
##SUPER LEARNER##
prediction.function <- SuperLearner(Y=Y.train, X = X.train, SL.library = SL.library, family = gaussian())
#where Y is the outcome, X is matrix of covariates you would like to consider, and family tells the 
#function whether or not your outcome is binary or continuous.
prediction.function

##to get new predictions using your function, you can use the predict function
out <- predict(prediction.function , newdata = X)
project4$SLpred <- out$pred


###################################################
##Bigger SL Library - Try some additional algorithms
#Still does not consider many of the most populat/best performing algorithms 
SL.library1 <- list(c("SL.glm", "screen.glmnet"),
                    c("SL.gam", "screen.glmnet"),
                    c("SL.earth", "screen.glmnet"),
                    c("SL.nnet", "screen.glmnet"),
                    c("SL.bayesglm", "screen.glmnet"),
                    "SL.glm", "SL.rpart","SL.randomForest", "SL.glmnet","SL.rpartPrune"
                    )

prediction.function1 <- SuperLearner(Y=Y.train, X = X.train, newX = X.train, SL.library = SL.library1, family = gaussian())

##Lets see how each algorithm performed and how much weight is given to each algorithm
prediction.function1

##to get new predictions using your function, you can use the predict function
out1 <-predict(prediction.function1 , newdata = X)
project4$SLpred2 <- out1$pred
