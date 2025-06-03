setwd("C:/Users/mpkhd/Documents/Uni Projects/Project3/RealWorld")
data <- read.csv("~/Uni Projects/Project3/RealWorld/data.csv", sep=",")

sum(duplicated(data))

library(dplyr)
df0 <- distinct(data,.keep_all=T)
summary(df0)
df0[,3] <- as.character(df0[,3])
dfcols <- colnames(df0)

cat_index <- c()
for(i in c(1:length(dfcols))){
  if (mode(df0[,i]) != "numeric"){
    cat_index <- c(cat_index,i)
  }else{
    i = i+1
  }
}

df0[, cat_index] <- lapply(df0[, cat_index], as.factor)
df0 <- as.data.frame(df0)
summary(df0)

real_world_props <- c(
  "ENFJ" = 2.5, "ENFP" = 8.1, "ENTJ" = 1.8, "ENTP" = 3.2,
  "ESFJ" = 12, "ESFP" = 8.5, "ESTJ" = 8.7,   "ESTP" = 4.3,
  "INFJ" = 1.5, "INFP" = 4.4, "INTJ" = 2.1, "INTP" = 3.3, 
  "ISFJ" = 13.8, "ISFP" = 8.8, "ISTJ" = 11.6, "ISTP" = 5.4
)/100


size <- dim(df0)
sample_counts <- round(real_world_props * size[1]/3)

set.seed(43)
sampled_data <- lapply(names(sample_counts), function(personality) {
  subset_data <- df0[df0$Personality == personality, ]
  sampled_subset <- subset_data[sample(1:nrow(subset_data), sample_counts[personality], replace = F), ]
  return(sampled_subset)
})

dfrw <- do.call(rbind, sampled_data)
dim(dfrw)


set.seed(43)
splitrw <- rsample::initial_split(dfrw, prop = 0.7, strata = Personality )
train <- rsample::training(splitrw)
test <- rsample::testing(splitrw)

write.csv(train, file = 'Train.csv', row.names = FALSE)
write.csv(test, file = 'Test.csv', row.names = FALSE)









