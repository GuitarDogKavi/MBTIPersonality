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


set.seed(123)
#--------------------------------Decision Tree-----------------------------------
library(caret)
library(rpart)

grid_dt <- expand.grid(cp = seq(0.001, 0.05, by = 0.005))
control <- trainControl(method = "cv", number = 5)

dt_model <- train(x = train[,-9],y = train[,9], 
                   method = "rpart",
                   trControl = control,
                   tuneGrid = grid_dt)

bestTree <- dt_model$finalModel

confusionMatrix(predict(bestTree, 
                        newdata = train[,-9], 
                        type = "class"),train[,9])


tree_pred <- predict(bestTree, 
                      newdata = test[,-9], 
                      type = "class")

tree_res <- confusionMatrix(tree_pred,test[,9])

importance <- varImp(dt_model, scale = FALSE)
plot(importance)





#-----------------------------------PDP ICE--------------------------------------
library(iml)
library(mlr)

predictor <- Predictor$new(
  model = bestTree,
  data = train %>% select(-Personality),  
  y = train$Personality,
  type = "prob"  
)


pdpE <- FeatureEffect$new(predictor, feature = "Education", method = "pdp")
plot(pdpE)

pdpG <- FeatureEffect$new(predictor, feature = "Gender", method = "pdp")
plot(pdpG)

pdpI <- FeatureEffect$new(predictor, feature = "Interest", method = "pdp")
plot(pdpI)

pdpJ <- FeatureEffect$new(predictor, feature = "Judging.Score", method = "pdp")
plot(pdpJ)

pdpS <- FeatureEffect$new(predictor, feature = "Sensing.Score", method = "pdp")
plot(pdpS)

pdpT <- FeatureEffect$new(predictor, feature = "Thinking.Score", method = "pdp")
plot(pdpT)

pdpI <- FeatureEffect$new(predictor, feature = "Introversion.Score", method = "pdp")
plot(pdpI)

pdpA <- FeatureEffect$new(predictor, feature = "Age", method = "pdp")
plot(pdpA)



#--------------------------------------rf-----------------------------------------
library(randomForest)

rf_grid <- expand.grid(mtry = c(2, 4, 6, 8, 10))

best_rf <- NULL
best_acc <- 0

for (nodesize in c(5, 10, 15)) {     
  for (maxnodes in c(20, 30, 40)) {
    for (ntree in c(100, 200, 300)) {
      rf_tune <- train(
        x = train[,-9],y = train[,9], 
        method = "rf",
        trControl = trainControl(method = "cv", number = 5),
        tuneGrid = rf_grid,
        ntree = ntree,      
        nodesize = nodesize,
        maxnodes = maxnodes)
      
      acc <- max(rf_tune$results$Accuracy)
      
      if (acc > best_acc) {
        best_acc <- acc
        best_rf <- rf_tune$finalModel
      }
    }
  }
}

rf_train <- confusionMatrix(predict(best_rf, newdata = train[,-9]), train[,9])
rf_res <- confusionMatrix(predict(best_rf, newdata = test[,-9]), test[,9])


library(dplyr)
rf_importance <- as.data.frame(importance(best_rf))
rf_importance$Feature <- rownames(rf_importance)

rf_importance <- rf_importance %>%
  arrange(desc(MeanDecreaseGini)) %>%
  head(15)

ggplot(rf_importance, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini, fill = MeanDecreaseGini)) +
  geom_bar(stat = "identity", width = 0.7) +
  coord_flip() +  
  scale_fill_gradient(low = "#69b3a2", high = "#ff4d4d") +
  theme_minimal() +
  labs(
    title = "Feature Importance (RF)",
    x = "Feature",
    y = "Mean Decrease in Gini Index"
  ) +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 12, face = "bold"),
    legend.position = "none"
  )

#--------------------------------------XGB---------------------------------------
library(ParBayesianOptimization)
library(xgboost)
library(caret)


train.xgbdata <- train[, -9]
train.xgbdata[, c(2,3,8)] <- lapply(train.xgbdata[, c(2,3,8)], as.numeric)
test.xgbdata <- test[, -9]
test.xgbdata[, c(2,3,8)] <- lapply(test.xgbdata[, c(2,3,8)], as.numeric)

trainMatrix <- as.matrix(train.xgbdata)
testMatrix <- as.matrix(test.xgbdata)

train_labels <- as.integer(train$Personality) - 1
test_labels <- as.integer(test$Personality) - 1

dtrain <- xgb.DMatrix(data = trainMatrix, label = train_labels)

scoringFunction <- function(max_depth, eta, nrounds, gamma, colsample_bytree, min_child_weight, subsample) {
  params <- list(
    booster = "gbtree",
    objective = "multi:softprob",
    num_class = length(unique(train_labels)),
    eval_metric = "mlogloss",
    max_depth = as.integer(max_depth),
    eta = eta,
    gamma = gamma,
    colsample_bytree = colsample_bytree,
    min_child_weight = min_child_weight,
    subsample = subsample
  )
  
  cv <- xgb.cv(
    params = params,
    data = dtrain,
    nrounds = as.integer(nrounds),
    nfold = 5,
    early_stopping_rounds = 10,
    verbose = 0
  )
  
  best_logloss <- min(cv$evaluation_log$test_mlogloss_mean)
  
  return(list(Score = -best_logloss))  # Negative because BayesianOptimization maximizes
}

optObj <- bayesOpt(
  FUN = scoringFunction,
  bounds = list(
    max_depth = c(3L, 6L),
    eta = c(0.01, 0.3),
    nrounds = c(100L, 400L),
    gamma = c(0, 10),
    colsample_bytree = c(0.5, 1.0),
    min_child_weight = c(1, 10),
    subsample = c(0.5, 1.0)
  ),
  initPoints = 10,
  iters.n = 20,
  acq = "ucb",  # Acquisition function
  verbose = 1
)
best_params <- getBestPars(optObj)

final_params <- list(
  booster = "gbtree",
  objective = "multi:softprob",
  num_class = length(unique(train_labels)),
  eval_metric = "mlogloss",
  max_depth = as.integer(best_params$max_depth),
  eta = best_params$eta,
  gamma = best_params$gamma,
  colsample_bytree = best_params$colsample_bytree,
  min_child_weight = best_params$min_child_weight,
  subsample = best_params$subsample
)

best_xgb_bayes <- xgb.train(
  params = final_params,
  data = dtrain,
  nrounds = as.integer(best_params$nrounds),
  verbose = 1
)

best_xgbcv_final <- best_xgb_bayes


xgb_trainpred <- predict(best_xgbcv_final, newdata = trainMatrix, reshape = TRUE)
xgb_trainpred_class <- levels(train[,9])[apply(xgb_trainpred, 1, which.max)]
xgb_res.trainclust <- confusionMatrix(factor(xgb_trainpred_class, levels = levels(train[,9])),train[,9])

xgb_pred <- predict(best_xgbcv_final, newdata = testMatrix, reshape = TRUE)
xgb_pred_class <- levels(train[,9])[apply(xgb_pred, 1, which.max)]
xgb_res.clust <- confusionMatrix(factor(xgb_pred_class, levels = levels(test[,9])),test[,9])


xgb_importance1 <- xgb.importance(feature_names = colnames(trainMatrix), model = best_xgbcv_final)
xgb_importance1_df <- as.data.frame(xgb_importance1)

xgb_importance1_df <- xgb_importance1_df %>%
  arrange(desc(Gain)) %>%  
  head(15)

ggplot(xgb_importance1_df, aes(x = reorder(Feature, Gain), y = Gain, fill = Gain)) +
  geom_bar(stat = "identity", width = 0.7) +
  coord_flip() +  
  scale_fill_gradient(low = "#69b3a2", high = "#ff4d4d") +
  theme_minimal() +
  labs(
    title = "Feature Importance (XGBoost Clust1)",
    x = "Feature",
    y = "Gain"
  ) +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 12, face = "bold"),
    legend.position = "none"
  )
