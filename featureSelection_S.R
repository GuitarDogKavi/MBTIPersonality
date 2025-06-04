setwd("C:/Users/mpkhd/Documents/Uni Projects/Project3/Synthetic")
train <- read.csv("~/Uni Projects/Project3/Synthetic/Train.csv", sep=",")
val <- read.csv("~/Uni Projects/Project3/Synthetic/RealWorldValidation.csv", sep=",")
test <- read.csv("~/Uni Projects/Project3/Synthetic/Test.csv", sep=",")

summary(train)
train[,3] <- as.character(train[,3])
traincols <- colnames(train)
cat_index <- c()
for(i in c(1:length(traincols))){
  if (mode(train[,i]) != "numeric"){
    cat_index <- c(cat_index,i)
  }else{
    i = i+1
  }
}
train[, cat_index] <- lapply(train[, cat_index], as.factor)
train <- as.data.frame(train)
summary(train)

summary(val)
val[,3] <- as.character(val[,3])
val[, cat_index] <- lapply(val[, cat_index], as.factor)
val <- as.data.frame(val)
summary(val)

summary(test)
test[,3] <- as.character(test[,3])
test[, cat_index] <- lapply(test[, cat_index], as.factor)
test <- as.data.frame(test)
summary(test)


#----------------------------------Transformed Data------------------------------
lambda_optimal5 <- 2
lambda_optimal7 <- 1.7

#Train
trainTrf <- train
trainTrf$Age <- log(trainTrf[,1]+1)
trainTrf$Sensing.Score <- (trainTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
trainTrf$Judging.Score <- (trainTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
trainTrf_X <- trainTrf[,-9] 
trainTrf_Y <- trainTrf[,9] 

#Val
valTrf <- val
valTrf$Age <- log(valTrf[,1]+1)
valTrf$Sensing.Score <- (valTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
valTrf$Judging.Score <- (valTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
valTrf_X <- valTrf[,-9] 
valTrf_Y <- valTrf[,9] 

#Test
testTrf <- test
testTrf$Age <- log(testTrf[,1]+1)
testTrf$Sensing.Score <- (testTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
testTrf$Judging.Score <- (testTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
testTrf_X <- testTrf[,-9] 
testTrf_Y <- testTrf[,9] 


#--------------------------------Feature Selection-------------------------------
library(caret)
dummies <- dummyVars(~ Gender + Education + Interest , data = trainTrf_X)
encoded_df <- predict(dummies, newdata = trainTrf_X)

trainTrf_XEnc <- cbind(trainTrf[,c(9,1,4:7)],encoded_df)

#------------------------------------Lasso---------------------------------------
trainMat = model.matrix(Personality ~ .-1,trainTrf_XEnc)

library(glmnet)
set.seed(5)
cv.lasso <- cv.glmnet(trainMat, trainTrf_Y, family = "multinomial", alpha = 1)
plot(cv.lasso)
lam.best=cv.lasso$lambda.min
coef(cv.lasso)
coef(cv.lasso,s=lam.best)
# No features were dropped??






