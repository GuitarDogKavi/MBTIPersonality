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


library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)
library(reshape2)

train %>% 
  keep(is.numeric) %>%
  gather() %>%
  ggplot(aes(value)) +
  facet_wrap(~ key, scales = 'free') +
  geom_density(color = 'black', fill = "#8bae87")

# distribution density for each numeric variable


#----------------Checking distribution of Numeric Variables----------------------
train %>% 
  keep(is.numeric) %>%
  gather(key = "Variable", value = "Value") %>% 
  ggplot(aes(sample = Value)) +
  facet_wrap(~ Variable, scales = "free") +
  stat_qq() + 
  stat_qq_line(color = "red") +
  theme_minimal()


library(e1071)
cols <- train %>%
  names

skew_values <- train %>%
  keep(is.numeric) %>%   
  map(~ skewness(.)) %>%
  set_names(names(train)[sapply(train, is.numeric)])
# from above values Age, Sensing, Thinking, Jdging will need log transformation



library(MASS)
trainTrf <- train
trainTrf$Age <- log(trainTrf[,1]+1)

epsilon <- 0.0001
shift_value <- ifelse(min(trainTrf[,5]) <= 0, abs(min(trainTrf[,5])) + epsilon, 0)
trainTrf[,5] <- trainTrf[,5] + shift_value
boxcox_result5 <- boxcox(trainTrf[,5] ~ 1, plotit = FALSE)
lambda_optimal5 <- boxcox_result5$x[which.max(boxcox_result5$y)]
trainTrf$Sensing.Score <- (trainTrf$Sensing.Score^lambda_optimal5 - 1) / lambda_optimal5

shift_value7 <- ifelse(min(trainTrf[,7]) <= 0, abs(min(trainTrf[,7])) + epsilon, 0)
trainTrf[,7] <- trainTrf[,7] + shift_value7
boxcox_result7 <- boxcox(trainTrf[,7] ~ 1, plotit = FALSE)
lambda_optimal7 <- boxcox_result7$x[which.max(boxcox_result7$y)]
trainTrf$Judging.Score <- (trainTrf$Judging.Score^lambda_optimal7 - 1) / lambda_optimal7


#----------------------------After Transformation--------------------------------
trainTrf %>% 
  keep(is.numeric) %>%
  gather() %>%
  ggplot(aes(value)) +
  facet_wrap(~ key, scales = 'free') +
  geom_density(color = 'blue', fill = 'red')

trainTrf %>% 
  keep(is.numeric) %>%
  gather(key = "Variable", value = "Value") %>% 
  ggplot(aes(sample = Value)) +
  facet_wrap(~ Variable, scales = "free") +
  stat_qq() + 
  stat_qq_line(color = "red") +
  theme_minimal()

skew_values_trf <- trainTrf %>%
  keep(is.numeric) %>%   
  map(~ skewness(.)) %>%
  set_names(names(train)[sapply(train, is.numeric)])



#----------------------------Categorical Variables-------------------------------

#Gender
ggplot(trainTrf, aes(x = Personality, fill = Gender)) +
  geom_bar(position = "fill")  +
  labs(
    title = "Gender Proportion across Personality",
    x = "Personality",
    y = "Proportion of Gender"
  ) +
  theme_minimal(base_size = 14) + 
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"), 
    axis.title.x = element_text(face = "bold"), 
    axis.title.y = element_text(face = "bold") 
  )


#Education - Not Sure about this variable might be useful.
ggplot(trainTrf, aes(x = Personality, fill = Education)) +
  geom_bar(position = "fill")  +
  labs(
    title = "Education Proportion across Personality",
    x = "Personality",
    y = "Proportion of Education"
  ) +
  theme_minimal(base_size = 14) + 
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"), 
    axis.title.x = element_text(face = "bold"), 
    axis.title.y = element_text(face = "bold") 
  )


#-----------------------------------Numerical------------------------------------
#Age
ggplot(trainTrf, aes(x = Personality, y = Age)) +
  geom_boxplot(color = "blue", fill = "lightblue") +
  labs(title = "Boxplot of Age across Personality Types",
       x = "Personality Type",
       y = "Age") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

#Introversion Score
ggplot(trainTrf, aes(x = Personality, y = Introversion.Score)) +
  geom_boxplot(color = "blue", fill = "lightblue") +
  labs(title = "Boxplot of Introversion.Score across Personality Types",
       x = "Personality Type",
       y = "Introversion.Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

#Sensing Score
ggplot(trainTrf, aes(x = Personality, y = Sensing.Score)) +
  geom_boxplot(color = "blue", fill = "lightblue") +
  labs(title = "Boxplot of Sensing.Score across Personality Types",
       x = "Personality Type",
       y = "Sensing.Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

#Thinking Score
ggplot(trainTrf, aes(x = Personality, y = Thinking.Score)) +
  geom_boxplot(color = "blue", fill = "lightblue") +
  labs(title = "Boxplot of Thinking.Score across Personality Types",
       x = "Personality Type",
       y = "Thinking.Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

#Judging Score
ggplot(trainTrf, aes(x = Personality, y = Judging.Score)) +
  geom_boxplot(color = "blue", fill = "lightblue") +
  labs(title = "Boxplot of Judging.Score across Personality Types",
       x = "Personality Type",
       y = "Judging.Score") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


#------------------------------------ANOVA---------------------------------------
AgeY <- aov(Age ~ Personality, data = trainTrf)
summary(AgeY)#looks to be significant

IntroversionY <- aov(Introversion.Score ~ Personality, data = trainTrf)
summary(IntroversionY)#looks to be significant

SensingY <- aov(Sensing.Score ~ Personality, data = trainTrf)
summary(SensingY)#looks to be significant

ThinkingY <- aov(Thinking.Score ~ Personality, data = trainTrf)
summary(ThinkingY)#looks to be significant

JudgingY <- aov(Judging.Score ~ Personality, data = trainTrf)
summary(JudgingY)#looks to be significant


#--------------------------------Heat Map----------------------------------------
corr_mat_q <- round(cor(trainTrf[,c(1,4:7)],method = 'spearman'),2)
melted_corr_mat_q <- melt(corr_mat_q)
head(melted_corr_mat_q)
ggplot(data = melted_corr_mat_q, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile() +
  geom_text(aes(Var2, Var1, label = value), 
            color = "black", size = 4) +
  scale_fill_distiller(palette = "RdBu", direction = 1) +
  labs(title = "Spearman Correlation Matrix ")


#-------------------------------------FAMD---------------------------------------
library(FactoMineR)

library(factoextra)

famd_result <- FAMD(trainTrf, graph = T)
fviz_famd_ind(famd_result, repel = T)
fviz_famd_var(famd_result, repel = T)
fviz_famd(famd_result, repel = T)