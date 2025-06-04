setwd("C:/Users/mpkhd/Documents/Uni Projects/Project3/Synthetic")
train <- read.csv("~/Uni Projects/Project3/Synthetic/Train.csv", sep=",")
# val <- read.csv("~/Uni Projects/Project3/Synthetic/RealWorldValidation.csv", sep=",")
test <- read.csv("~/Uni Projects/Project3/Synthetic/Test.csv", sep=",")
testRW <- read.csv("~/Uni Projects/Project3/Synthetic/TestRW.csv", sep=",")


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

# summary(val)
# val[,3] <- as.character(val[,3])
# val[, cat_index] <- lapply(val[, cat_index], as.factor)
# val <- as.data.frame(val)
# summary(val)

summary(test)
test[,3] <- as.character(test[,3])
test[, cat_index] <- lapply(test[, cat_index], as.factor)
test <- as.data.frame(test)
summary(test)

summary(testRW)
testRW[,3] <- as.character(testRW[,3])
testRW[, cat_index] <- lapply(testRW[, cat_index], as.factor)
testRW <- as.data.frame(testRW)
summary(testRW)

library(dplyr)
test0 <- anti_join(testRW,test)
test0 <- anti_join(test0,train)
write.csv(test0, file = 'TestRWUnique.csv', row.names = FALSE)

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

# #Val
# valTrf <- val
# valTrf$Age <- log(valTrf[,1]+1)
# valTrf$Sensing.Score <- (valTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
# valTrf$Judging.Score <- (valTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
# valTrf_X <- valTrf[,-9] 
# valTrf_Y <- valTrf[,9] 

#Test
testTrf <- test
testTrf$Age <- log(testTrf[,1]+1)
testTrf$Sensing.Score <- (testTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
testTrf$Judging.Score <- (testTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7
testTrf_X <- testTrf[,-9] 
testTrf_Y <- testTrf[,9] 

test0 <- read.csv("~/Uni Projects/Project3/Synthetic/TestRWUnique.csv", sep=",")
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
predicted_probabilitiesV <- predict(model, newdata = test0Trf, type = "probs")
predicted_classesV <- predict(model, newdata = test0Trf, type = "class")


library(caret)
confusion_matrix <- confusionMatrix(predicted_classesV, test0Trf$Personality)
print(confusion_matrix)
print(confusionMatrix(predict(model, newdata = trainTrf, type = "class"), trainTrf$Personality))

library(pROC)
actual_labels <- factor(valTrf$Personality, levels = levels(valTrf$Personality))
roc_curve <- multiclass.roc(actual_labels, as.numeric(predicted_probabilitiesV))
auc(roc_curve)







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






real_world_props <- c(
  "ENFJ" = 2.5, "ENFP" = 8.1, "ENTJ" = 1.8, "ENTP" = 3.2,
  "ESFJ" = 12, "ESFP" = 8.5, "ESTJ" = 8.7, "ESTP" = 4.3,
  "INFJ" = 1.5, "INFP" = 4.4, "INTJ" = 2.1, "INTP" = 3.3, 
  "ISFJ" = 13.8, "ISFP" = 8.8, "ISTJ" = 11.6, "ISTP" = 5.4
) 

# Get the frequency of each class in the training set
train_class_counts <- table(trainTrf$Personality)
train_class_props <- train_class_counts / sum(train_class_counts)
# Compute the weight for each class
rw_weights <- real_world_props / train_class_props


trainTrf$Weights <- as.numeric(rw_weights[trainTrf$Personality])

weight_model <- multinom(Personality ~ Age + Introversion.Score + Sensing.Score + 
                    Thinking.Score + Judging.Score + Gender + Education + Interest, 
                  data = trainTrf,weights = trainTrf$Weights)
summary(weight_model)
predicted_probabilitiesVW <- predict(weight_model, newdata = valTrf, type = "probs")
predicted_classesVW <- predict(weight_model, newdata = valTrf, type = "class")

confusion_matrixW <- confusionMatrix(predicted_classesVW, valTrf$Personality)
print(confusion_matrixW)













