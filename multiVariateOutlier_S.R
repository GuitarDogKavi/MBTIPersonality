setwd("C:/Users/mpkhd/Documents/Uni Projects/Project3/Synthetic")
train <- read.csv("~/Uni Projects/Project3/Synthetic/Train.csv", sep=",")

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


#----------------------------------Transformed Data------------------------------
trainTrf <- train
trainTrf$Age <- log(trainTrf[,1]+1)

lambda_optimal5 <- 2
lambda_optimal7 <- 1.7
trainTrf$Sensing.Score <- (trainTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
trainTrf$Judging.Score <- (trainTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7

trainTrf_X <- trainTrf[,-9] 
trainTrf_Y <- trainTrf[,9] 


#-----------------------------------Factors--------------------------------------
library(FactoMineR)
library(factoextra)
famd_result <- FAMD(trainTrf, graph = T)
fviz_famd_ind(famd_result, repel = T)
fviz_famd_var(famd_result, repel = T)
fviz_famd(famd_result, repel = T)
famdVal <- as.data.frame(famd_result$ind$coord)


#------------------------Checking for Multivariate Normality---------------------
library(MVN)
result <- mvn(data = trainTrf[,c(1,4:7)], mvnTest = "mardia")
result$multivariateNormality #Not multivariate Normal


#--------------------------Robust Mahalanobis Distance---------------------------
numeric_vars <- trainTrf[,c(1,4:7)]
robust_cov <- cov.mcd(numeric_vars)
robust_mahal <- mahalanobis(numeric_vars, robust_cov$center, robust_cov$cov)

qqplot(qchisq(ppoints(length(robust_mahal)), df = ncol(numeric_vars)), 
       robust_mahal, 
       main = "QQ-Plot of Robust MD",
       xlab = "Theoretical Quantiles",
       ylab = "Robust MD")
abline(0, 1, col = "red")

MD_outliers <- which(robust_mahal > quantile(robust_mahal, 0.975)) # beyond 97.5 quantile
famdVal$MDoutlier <- ifelse(1:nrow(trainTrf) %in% MD_outliers, "Yes", "No")
famdVal$MDoutlier <- as.factor(famdVal$MDoutlier)

#-------------------------Multivariate Outlier Plot------------------------------
ggplot(famdVal, aes(Dim.1, Dim.2,color = MDoutlier)) + 
  geom_point() + 
  theme_minimal() +
  ggtitle('Analysing Outliers')
sum(famdVal$MDoutlier == "Yes")/nrow(famdVal)


