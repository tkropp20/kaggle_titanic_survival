# Kaggle competition: https://www.kaggle.com/c/titanic/
# Tutorial: http://trevorstephens.com/kaggle-titanic-tutorial/r-part-1-booting-up/


# Step 1: Set working directory and import data files

setwd("~/R Projects/Titanic Survival")

library(readr)
train <- read_csv("~/R Projects/Titanic Survival/Data/train.csv")
View(train)

library(readr)
test <- read_csv("~/R Projects/Titanic Survival/Data/test.csv")
View(test)

# Data Interrogation
# How many people died/survived in the training data set?
table(train$Survived)

# Propotion of who survived and who died in the training dataset
prop.table(table(train$Survived))


# Adding "Everyone dies" predition to the test set dataframe by adding "survived" column with a value of 0 for all rows
test$Survived <- rep(0, 418)

# Verify that the new column was added

View(test)

# Create a new dataframe with the result data and save to csv

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)

write.csv(submit, file = "theyallperish.csv", row.names = FALSE)
