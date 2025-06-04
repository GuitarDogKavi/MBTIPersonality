setwd("C:/Users/mpkhd/Documents/Uni Projects/Project3/RealWorld")
train <- read.csv("~/Uni Projects/Project3/RealWorld/Train.csv", sep=",")
test <- read.csv("~/Uni Projects/Project3/RealWorld/Test.csv", sep=",")

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

summary(test)
test[,3] <- as.character(test[,3])
test[, cat_index] <- lapply(test[, cat_index], as.factor)
test <- as.data.frame(test)
summary(test)


#----------------------------------Transformed Data------------------------------
lambda_optimal5 <- 2
lambda_optimal7 <- 1.9

#Train
trainTrf <- train
trainTrf$Age <- log(trainTrf[,1]+1)
trainTrf$Sensing.Score <- (trainTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
trainTrf$Judging.Score <- (trainTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
trainTrf_X <- trainTrf[,-9] 
trainTrf_Y <- trainTrf[,9] 

#Test
testTrf <- test
testTrf$Age <- log(testTrf[,1]+1)
testTrf$Sensing.Score <- (testTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
testTrf$Judging.Score <- (testTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
testTrf_X <- testTrf[,-9] 
testTrf_Y <- testTrf[,9] 

test0 <- read.csv("~/Uni Projects/Project3/RealWorld/TestRWUnique.csv", sep=",")
summary(test0)
test0[,3] <- as.character(test0[,3])
test0[, cat_index] <- lapply(test0[, cat_index], as.factor)
test0 <- as.data.frame(test0)
summary(test0)

#Test0
test0Trf <- test0
test0Trf$Age <- log(test0Trf[,1]+1)
test0Trf$Sensing.Score <- (test0Trf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
test0Trf$Judging.Score <- (test0Trf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
test0Trf_X <- test0Trf[,-9] 
test0Trf_Y <- test0Trf[,9] 


#----------------------------Multinomial Logistic Regression---------------------
library(nnet)
model <- multinom(Personality ~ Age + Introversion.Score + Sensing.Score + 
                    Thinking.Score + Judging.Score + Gender + Education + Interest, 
                  data = trainTrf)
summary(model)
predicted_probabilitiesV <- predict(model, newdata = testTrf, type = "probs")
predicted_classesV <- predict(model, newdata = test0Trf, type = "class")

saveRDS(model, "model.RDS")

library(caret)
confusion_matrix <- confusionMatrix(predicted_classesV, test0Trf$Personality)
print(confusion_matrix)
testConMat <- confusionMatrix(predict(model, newdata = trainTrf, type = "class"), trainTrf$Personality)
trainConMat <- confusionMatrix(predict(model, newdata = testTrf, type = "class"), testTrf$Personality)
print(testConMat)
print(trainConMat)


library(pROC)
actual_labels <- factor(valTrf$Personality, levels = levels(valTrf$Personality))
roc_curve <- multiclass.roc(actual_labels, as.numeric(predicted_probabilitiesV))
auc(roc_curve)



XTrf <- testTrf[2,]
X <- test[2,]


roc_curves <- list()
for (class in levels(actual_labels)) {
  binary_labels <- as.numeric(actual_labels == class)
  class_probabilities <- predicted_probabilitiesV[, class]
  roc_curve <- roc(binary_labels, class_probabilities)
  roc_curves[[class]] <- roc_curve
}
plot(roc_curves[[1]], col = "red", main = "ROC Curves for Multiclass Classification")
for (i in 2:length(roc_curves)) {
  lines(roc_curves[[i]], col = rainbow(length(roc_curves))[i])
}
legend("bottomright", legend = levels(actual_labels), col = rainbow(length(roc_curves)), lwd = 2)



