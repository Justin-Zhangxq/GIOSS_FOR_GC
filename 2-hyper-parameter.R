library(tidyverse)
library(ggplot2)
library(randomForest)
library(rms)
library(readxl)
library(randomForest)
library(writexl)
library(pROC)
library(dplyr)
library(openxlsx)
library(caret)
library(rpart)
library(e1071)
train.data <- read_excel("data_for_elderly_GC_based_on_GIOSS.xlsx", 
                         sheet = "Train")
test.data <- read_excel("data_for_elderly_GC_based_on_GIOSS.xlsx", 
                        sheet = "Test")
vali.data <- read_excel("data_for_elderly_GC_based_on_GIOSS.xlsx", 
                        sheet = "Vali")
# Load required libraries
library(rpart)
library(readxl)

# Load data from Excel file
train.data <- read_excel("OS总训练验证.xlsx", sheet = "Train")
test.data <- read_excel("OS总训练验证.xlsx", sheet = "Test")

# Convert all variables to factors
train.data <- lapply(train.data, factor)
test.data <- lapply(test.data, factor)

# Check data types
class(train.data)
class(test.data)

# Convert to data frames if necessary
train.data <- as.data.frame(train.data)
test.data <- as.data.frame(test.data)

# Recheck data types
class(train.data)
class(test.data)

# Modify dependent variable labels to "Alive" and "Dead"
train.data$OSstatus <- ifelse(train.data$OSstatus == 0, "Alive", "Dead")
test.data$OSstatus <- ifelse(test.data$OSstatus == 0, "Alive", "Dead")

# Build decision tree model using all variables
dtree <- rpart(OSstatus ~ ., data = train.data, method = "class", parms = list(split = "information"))

# Display cross-validation table
dtree$cptable

# Plot cross-validation results
plotcp(dtree)

# Find the optimal complexity parameter (CP) value
min_cp <- dtree$cptable[which.min(dtree$cptable[, "xerror"]), "CP"]

# Output the best CP value
cat("Best CP value:", min_cp, "\n")

# Get the number of rows in the training data
n <- nrow(train.data)

# Set the number of cross-validation folds, ensuring it doesn't exceed the sample size
cross_val <- min(10, n)

# Perform SVM parameter tuning
# This process may take approximately 1 hour to complete
tuned <- tune.svm(OSstatus~., data=train.data, 
                  gamma=10^(-6:-1),
                  cost=10^(-6:6),
                  tunecontrol = tune.control(cross = cross_val), 
                  max_iter = 1000000000)

# Display the tuning results
tuned
