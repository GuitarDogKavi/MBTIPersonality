setwd("C:/Users/mpkhd/Documents/Uni Projects/Project3/RealWorld")
train <- read.csv("~/Uni Projects/Project3/RealWorld/Train.csv", sep=",")

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
lambda_optimal7 <- 1.9
trainTrf$Sensing.Score <- (trainTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5
trainTrf$Judging.Score <- (trainTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7

trainTrf_X <- trainTrf[,-9] 
trainTrf_Y <- trainTrf[,9] 


#------------------------------------Silhouette----------------------------------

library(clustMixType)
wss <- numeric(10)  # Store within-cluster sum of squares
for (k in 2:10) {
  kproto_temp <- kproto(trainTrf, k, type = "huang")
  wss[k] <- sum(kproto_temp$tot.withinss)
}

# Plot Elbow Method
plot(2:10, wss[2:10], type="b", pch=19, frame=FALSE,
     xlab="Number of clusters (k)", ylab="Total Within-Cluster SS",
     main="Elbow Method for Optimal K")


library(cluster)
kproto_res <- kproto(trainTrf_X, k = 4)
clusters <- kproto_res$cluster
train$ClusterID <- kproto_res$cluster

#--------------------------------------------------------------------------------

#Do not Run the below Computationally Very Expensive
gower_dist <- daisy(trainTrf_X, metric = "gower")

#--------------------------------------------------------------------------------
silhouette_score <- silhouette(clusters, dist = gower_dist)
library(factoextra)
fviz_silhouette(silhouette_score)
summary(silhouette_score)
