# -------------------------------
# Kaggle competition: https://www.kaggle.com/c/titanic/
# Tutorial: http://trevorstephens.com/kaggle-titanic-tutorial/getting-started-with-r/
# -------------------------------

# -------------------------------
# Tutorial Part 1 - http://trevorstephens.com/kaggle-titanic-tutorial/r-part-1-booting-up
# -------------------------------

# Set working directory and import data files

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

# -------------------------------
# Tutorial part 2 - http://trevorstephens.com/kaggle-titanic-tutorial/r-part-2-the-gender-class-model
# -------------------------------

# Change the Sex data type so that it's catagorical
train$Sex <- as.factor(train$Sex)

# Look at the gender data, did a higher proportion of women survive?
summary(train$Sex)

prop.table(table(train$Sex, train$Survived),1)

# Alter the test data to set all females to survive

test$Survived[test$Sex == 'female'] <- 1
View(test$Survived)

# Create a new dataframe with the result data and save to csv

submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)

write.csv(submit, file = "allmalesperish.csv", row.names = FALSE)

# Next look at the age data, any obvious correllation with survival?

summary(train$Age)

# Add a field to the frame to indicate which passengers were children

train$Child <- 0

train$Child[train$Age < 18] <- 1

# See the number of people who survived by age and gender

aggregate(Survived ~ Child + Sex, data=train, FUN=sum)

# See the number of people by age and gender

aggregate(Survived ~ Child + Sex, data=train, FUN=length)

# See the proportion of people who survived by age and gender

aggregate(Survived ~ Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)})

# Categorize the fare data into 4 bins: < 10, 10-20, 20-30, 30+

train$FareBin <- '30+'
train$FareBin[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$FareBin[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$FareBin[train$Fare < 10] <- '<10'

# See the proportion of people who suvived by Fare Bin, Passenger Class, and Sex

aggregate(Survived ~ FareBin + Pclass + Sex, data=train, FUN = function(x) {sum(x)/length(x)})

# Create new output file where females in PAssenger Class 3 and paid more than $20 all die

test$Survived <- 0
test$Survived[test$Sex == 'female'] <-1
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare <= 20] <-0
write.csv(submit, file = "allmalesandfemalesinclass3perish.csv", row.names = FALSE)
