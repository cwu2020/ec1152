

#Change this to location of your data
#Can use drop down menu in R studio: file->import data set-> from stata and find stata data set
setwd(dir = "/Users/carrawu/Documents/harvard/ec1152")

if (!require(foreign)) install.packages("foreign"); library(foreign)
if (!require(haven)) install.packages("haven"); library(haven)
if (!require(randomForest)) install.packages("randomForest"); library(randomForest)
if (!require(rpart)) install.packages("rpart"); library(rpart)

#Open stata data set
proj4 <- read_dta("project4.dta")
head(proj4)

#Storing predictor variables
#Order data in stata so all predictors appear in right-most columns
vars <- colnames(proj4[10:ncol(proj4)])

#OLS Regression
to_hat <- with(proj4[proj4$training==1,], lm(reformulate(vars, "kfr_pooled_p25")))
summary(to_hat)
rank_hat_ols = predict(to_hat, newdata=proj4)
summary(rank_hat_ols); hist(rank_hat_ols, xlab="Predicted Rates - OLS")

#Decision Tree or Regression Tree
one_tree <- rpart(reformulate(vars, "kfr_pooled_p25")
                  , data=proj4
                  , subset = training==1
                  , control = rpart.control(xval = 10)) ## this sets the number of folds for cross validation.

one_tree #Text Representation of Tree
rank_hat_tree <- predict(one_tree, newdata=proj4)
table(rank_hat_tree)
hist(rank_hat_tree, xlab="Predicted Rates - Single Tree")

plot(one_tree) # plot tree
text(one_tree) # add labels to tree
# print complexity parameter table using cross validation
printcp(one_tree)

#Random Forest from 1000 Bootstrapped Samples
forest_hat <- randomForest(reformulate(vars, "kfr_pooled_p25"), ntree=1000, mtry=11, maxnodes=100
                           ,importance=TRUE, do.trace=25, data=proj4[proj4$training==1,], no.action = na.omit)
getTree(forest_hat, 250, labelVar = TRUE) #Text Representation of Tree
rank_hat_forest <- predict(forest_hat, data=proj4,type="response")
summary(rank_hat_forest); hist(rank_hat_forest, xlab="Predicted Rates - Random Forest")

proj4$rank_hat_forest = rank_hat_forest
proj4$rank_hat_ols = rank_hat_ols
proj4$rank_hat_tree = rank_hat_tree

forest_pred_error <- proj4$kfr_pooled_p25[proj4$training == 1] - proj4$rank_hat_forest[proj4$training == 1]
ols_pred_error <- proj4$kfr_pooled_p25[proj4$training == 1] - proj4$rank_hat_ols[proj4$training == 1]
tree_pred_error <- proj4$kfr_pooled_p25[proj4$training == 1] - proj4$rank_hat_tree[proj4$training == 1]

proj4$mse_forest = forest_pred_error^2
proj4$mse_ols = ols_pred_error^2
proj4$mse_tree = tree_pred_error^2

#mse for forest in sample
mean(proj4$mse_forest)
mean(proj4$mse_ols)
mean(proj4$mse_tree)

#Export to stata
proj4$predictions_ols <- rank_hat_ols #Add OLS predictions to data set
proj4$predictions_tree <- rank_hat_tree #Add regression tree predictions to data set
proj4$predictions_forest <- rank_hat_forest #Add random forest predictions to data set
write.dta(proj4, "proj4_results.dta") #Save data as a stata .dta file

#project4$pred_error = project4$kfr_actual -project4$predictions
#project4$mse_forest = project4$pred_error^2
#mse_test <- subset(proj4, test==0, select = c(mse_forest,mse_trees,mse_ols)) 
#summary(mse_test)

library("haven")


gdc<-read_dta("atlas_test.dta")
gdc<-merge(gdc,proj4,by = "geoid")

gdc$rank_hat_forest = rank_hat_forest
gdc$rank_hat_ols = rank_hat_ols
gdc$rank_hat_tree = rank_hat_tree

forest_pred_error <- gdc$kfr_actual[gdc$training == 0] - gdc$rank_hat_forest[gdc$training == 0]
ols_pred_error <- gdc$kfr_actual[gdc$training == 0] - gdc$rank_hat_ols[gdc$training == 0]
tree_pred_error <- gdc$kfr_actual[gdc$training == 0] - gdc$rank_hat_tree[gdc$training == 0]

gdc$mse_forest = forest_pred_error^2
gdc$mse_ols = ols_pred_error^2
gdc$mse_tree = tree_pred_error^2

#mse for forest in sample
mean(gdc$mse_forest)
mean(gdc$mse_ols)
mean(gdc$mse_tree)

gdc$predictions_ols <- rank_hat_ols #Add OLS predictions to data set
gdc$predictions_tree <- rank_hat_tree #Add regression tree predictions to data set
gdc$predictions_forest <- rank_hat_forest #Add random forest predictions to data set
write.dta(gdc, "gdc_results.dta") #Save data as a stata .dta file

plot(gdc$rank_hat_forest[gdc$test==1],gdc$kfr_actual[gdc$test==1], xlab = "Forest Prediction", ylab = "kfr_actual")
abline(lm(gdc$kfr_actual[gdc$test==1]~gdc$rank_hat_forest[gdc$test==1]))
#plot(predictions_forest, kfr_actual)
#plot(predictions_tree, kfr_actual)
