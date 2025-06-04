setwd("C:/Users/mpkhd/Documents/Uni Projects/Project3/Synthetic")
data <- read.csv("~/Uni Projects/Project3/Synthetic/data.csv", sep=",")

sum(duplicated(data))

library(dplyr)
df <- distinct(data,.keep_all=T)
summary(df)
df[,3] <- as.character(df[,3])
dfcols <- colnames(df)

cat_index <- c()
for(i in c(1:length(dfcols))){
  if (mode(df[,i]) != "numeric"){
    cat_index <- c(cat_index,i)
  }else{
    i = i+1
  }
}

df[, cat_index] <- lapply(df[, cat_index], as.factor)
df <- as.data.frame(df)
summary(df)

set.seed(42)
splitr <- rsample::initial_split(df, prop = 0.7, strata = Personality )
train <- rsample::training(splitr)
test <- rsample::testing(splitr)


real_world_props <- c(
  "ENFJ" = 2.5, "ENFP" = 8.1, "ENTJ" = 1.8, "ENTP" = 3.2,
  "ESFJ" = 12, "ESFP" = 8.5, "ESTJ" = 8.7,   "ESTP" = 4.3,
  "INFJ" = 1.5, "INFP" = 4.4, "INTJ" = 2.1, "INTP" = 3.3, 
  "ISFJ" = 13.8, "ISFP" = 8.8, "ISTJ" = 11.6, "ISTP" = 5.4
)/100


size <- dim(test)

sample_counts <- round(real_world_props * size[1]/3)

set.seed(43)
sampled_data <- lapply(names(sample_counts), function(personality) {
  subset_data <- test[test$Personality == personality, ]
  sampled_subset <- subset_data[sample(1:nrow(subset_data), sample_counts[personality], replace = F), ]
  return(sampled_subset)
})

real_world_validation <- do.call(rbind, sampled_data)
testF <- anti_join(test, final_sampled_data, by = colnames(test))



