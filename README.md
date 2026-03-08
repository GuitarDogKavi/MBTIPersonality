# A PREDICTIVE MODEL FOR MBTI TYPES USING DEMOGRAPHIC AND PHSYCOLOGIC DATA

## Overview
This project builds a machine learning pipeline to predict Myers–Briggs Type Indicator (MBTI) personality types using demographic characteristics and psychological trait scores.

Using a dataset of 43,744 individuals, we investigate how variables such as age, gender, education, interests, and personality trait scores relate to the 16 MBTI personality types. The project combines statistical analysis, dimensionality reduction, clustering analysis, and supervised machine learning to understand personality patterns and build predictive models.

The final model predicts personality type with strong performance while maintaining good generalization.


## Problem Statement
This project investigates whether demographic and psychological features can be used to predict MBTI personality types using machine learning models.



## Objectives
Develop a machine learning model capable of predicting MBTI personality types using demographic and psychological attributes.

Explore relationships between personality traits and demographic factors

Identify statistically significant trends in MBTI distributions

Validate patterns observed in psychological literature

Compare performance of multiple classification algorithms



## Dataset Characteristsics
Total observations: 43,744

Duplicate observations removed

Final sampled dataset: 14,240 observations

The dataset is availble at https://www.kaggle.com/datasets/stealthtechnologies/predict-people-personality-types

The sampled dataset was constructed to reflect real-world MBTI personality distributions.



## EDA
Initial analysis included: Distribution analysis, transformation of skewed variables, hypothesis testing, clustering analysis, dimensionality reduction.

Variables such as Age, Sensing Score, and Judging Score were transformed to reduce skewness and improve statistical validity.



## Statistical Analysis
Several statistical tests were conducted to validate relationships between personality traits and demographic variables.

Age and Personality: A Kruskal–Wallis test indicated significant differences in age distribution across personality types.

Key observation: Sensing types tend to appear more frequently in older age groups. Intuitive types are more common among younger individuals.


Gender and Personality Traits: Using the Wilcoxon Rank-Sum Test, significant differences were observed in Introversion score and Thinking score.

A Chi-square test indicated a significant association between personality type and interest areas.
Examples: SF and ST types were more common in sports and arts while NT and NF types appeared more frequently among graduate-level education groups



## Dimensionality Reduction
Factor Analysis of Mixed Data (FAMD) was used to analyze relationships between mixed variable types.

Findings: Thinking, Judging, and Introversion scores contributed strongly to variance. Demographic variables had smaller influence.

The first two dimensions explained approximately 16% of the total variance, which is expected for complex behavioral data.

## Outlier Detection

Outliers were detected using the Mahalanobis distance method. Since the data did not follow multivariate normality (based on the Mardia test), robust distance metrics were used.

Result: A few observations were identified as potential outliers. After inspection, none were removed as they represented valid observations.



## Cluster Analysis

Clustering was performed using K-Prototypes clustering, suitable for datasets with mixed numerical and categorical variables.

Distance measures used: Euclidean distance for numerical variables and Hamming distance for categorical variables

Results: Optimal clusters suggested by the elbow method were 4 clusters. However Silhouette scores indicated weak cluster separation.

Conclusion: Personality types do not form clearly separable clusters in the feature space.



## Variable Selection
Feature selection was performed using LASSO logistic regression. Following the 1-standard-deviation rule, all variables were retained for model training.



## Machine Learning Models

The following classification models were trained: Multinomial Logistic Regression, Random Forest, XGBoost, Decision Tree



## Model Interpretation
Model interpretability techniques included: Feature Importance, Partial Dependence Plots (PDP), Individual Conditional Expectation (ICE)
