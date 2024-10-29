# Data Preprocessing
# Convert all variables in train.data, test.data, and vali.data to factors
train.data <- lapply(train.data, factor)
test.data <- lapply(test.data, factor)
vali.data <- lapply(vali.data, factor)

# Convert to data frames
train.data <- as.data.frame(train.data)
test.data <- as.data.frame(test.data)
vali.data <- as.data.frame(vali.data)

# Check data types
class(train.data)
class(test.data)
class(vali.data)

# Random Forest (RF) Model
fit.forest <- randomForest(OSstatus ~ ., data = train.data, mode = "classification",
                           na.action = na.roughfix, importance = TRUE)

# Predictions and AUC calculations for RF
train.pred.probs.RF <- predict(fit.forest, train.data, type = "prob")[, "1"]
train.auc.RF <- auc(roc(train.data$OSstatus, train.pred.probs.RF))
train.ci.RF <- ci.auc(roc(train.data$OSstatus, train.pred.probs.RF))

test.pred.probs.RF <- predict(fit.forest, test.data, type = "prob")[, "1"]
test.auc.RF <- auc(roc(test.data$OSstatus, test.pred.probs.RF))
test.ci.RF <- ci.auc(roc(test.data$OSstatus, test.pred.probs.RF))

vali.pred.probs.RF <- predict(fit.forest, vali.data, type = "prob")[, "1"]
vali.auc.RF <- auc(roc(vali.data$OSstatus, vali.pred.probs.RF))
vali.ci.RF <- ci.auc(roc(vali.data$OSstatus, vali.pred.probs.RF))

# Decision Tree (DT) Model
dtree <- rpart(OSstatus ~ ., data = train.data, method = "class", parms = list(split = "information"))
dtree.pruned <- prune(dtree, cp = 0.01)

# Predictions and AUC calculations for DT
train.prob.DT <- predict(dtree.pruned, newdata = train.data, type = "prob")[, "1"]
train.roc.DT <- roc(train.data$OSstatus, train.prob.DT)
train.auc.DT <- auc(train.roc.DT)
train.ci.DT <- ci.auc(train.roc.DT)

test.prob.DT <- predict(dtree.pruned, newdata = test.data, type = "prob")[, "1"]
test.roc.DT <- roc(test.data$OSstatus, test.prob.DT)
test.auc.DT <- auc(test.roc.DT)
test.ci.DT <- ci.auc(test.roc.DT)

vali.prob.DT <- predict(dtree.pruned, newdata = vali.data, type = "prob")[, "1"]
vali.roc.DT <- roc(vali.data$OSstatus, vali.prob.DT)
vali.auc.DT <- auc(vali.roc.DT)
vali.ci.DT <- ci.auc(vali.roc.DT)

# Support Vector Machine (SVM) Model
fit.svm <- svm(OSstatus ~ ., data = train.data, gamma = 0.01, cost = 1, probability = TRUE)

# Predictions and AUC calculations for SVM
train.pred.SVM <- predict(fit.svm, train.data, probability = TRUE)
train.prob.SVM <- attr(train.pred.SVM, "probabilities")[, "1"]
train.roc.SVM <- roc(train.data$OSstatus, train.prob.SVM)
train.auc.SVM <- auc(train.roc.SVM)
train.ci.SVM <- ci(train.roc.SVM)

test.pred.SVM <- predict(fit.svm, test.data, probability = TRUE)
test.prob.SVM <- attr(test.pred.SVM, "probabilities")[, "1"]
test.roc.SVM <- roc(test.data$OSstatus, test.prob.SVM)
test.auc.SVM <- auc(test.roc.SVM)
test.ci.SVM <- ci(test.roc.SVM)

vali.pred.SVM <- predict(fit.svm, vali.data, probability = TRUE)
vali.prob.SVM <- attr(vali.pred.SVM, "probabilities")[, "1"]
vali.roc.SVM <- roc(vali.data$OSstatus, vali.prob.SVM)
vali.auc.SVM <- auc(vali.roc.SVM)
vali.ci.SVM <- ci(vali.roc.SVM)

# Output results
cat("DT Training Set AUC:", train.auc.DT, "\t 95% CI:", train.ci.DT[1], "-", train.ci.DT[3], "\n")
cat("DT Test Set AUC:", test.auc.DT, "\t 95% CI:", test.ci.DT[1], "-", test.ci.DT[3], "\n")
cat("DT Validation Set AUC:", vali.auc.DT, "\t 95% CI:", vali.ci.DT[1], "-", vali.ci.DT[3], "\n")

cat("RF Training Set AUC:", train.auc.RF, "\t 95% CI:", train.ci.RF[1], "-", train.ci.RF[3], "\n")
cat("RF Test Set AUC:", test.auc.RF, "\t 95% CI:", test.ci.RF[1], "-", test.ci.RF[3], "\n")
cat("RF Validation Set AUC:", vali.auc.RF, "\t 95% CI:", vali.ci.RF[1], "-", vali.ci.RF[3], "\n")

cat("SVM Training Set AUC:", train.auc.SVM, "\t 95% CI:", train.ci.SVM[1], "-", train.ci.SVM[3], "\n")
cat("SVM Test Set AUC:", test.auc.SVM, "\t 95% CI:", test.ci.SVM[1], "-", test.ci.SVM[3], "\n")
cat("SVM Validation Set AUC:", vali.auc.SVM, "\t 95% CI:", vali.ci.SVM[1], "-", vali.ci.SVM[3], "\n")

# Ensure required libraries are installed and loaded
if(!require(pROC)) {
  install.packages("pROC")
  library(pROC)
}

# Perform DeLong test on training set
roc.obj.train.RF <- roc(train.data$OSstatus, train.pred.probs.RF)
roc.obj.train.DT <- roc(train.data$OSstatus, train.prob.DT)
roc.obj.train.SVM <- roc(train.data$OSstatus, train.prob.SVM)

# Perform DeLong test on test set
roc.obj.test.RF <- roc(test.data$OSstatus, test.pred.probs.RF)
roc.obj.test.DT <- roc(test.data$OSstatus, test.prob.DT)
roc.obj.test.SVM <- roc(test.data$OSstatus, test.prob.SVM)

# Perform DeLong test on validation set
roc.obj.vali.RF <- roc(vali.data$OSstatus, vali.pred.probs.RF)
roc.obj.vali.DT <- roc(vali.data$OSstatus, vali.prob.DT)
roc.obj.vali.SVM <- roc(vali.data$OSstatus, vali.prob.SVM)

# Compare ROC curves on training set
roc.test.train.RFvsDT <- roc.test(roc.obj.train.RF, roc.obj.train.DT, method="delong")
roc.test.train.RFvsSVM <- roc.test(roc.obj.train.RF, roc.obj.train.SVM, method="delong")
roc.test.train.DTvsSVM <- roc.test(roc.obj.train.DT, roc.obj.train.SVM, method="delong")

# Compare ROC curves on test set
roc.test.test.RFvsDT <- roc.test(roc.obj.test.RF, roc.obj.test.DT, method="delong")
roc.test.test.RFvsSVM <- roc.test(roc.obj.test.RF, roc.obj.test.SVM, method="delong")
roc.test.test.DTvsSVM <- roc.test(roc.obj.test.DT, roc.obj.test.SVM, method="delong")

# Compare ROC curves on validation set
roc.test.vali.RFvsDT <- roc.test(roc.obj.vali.RF, roc.obj.vali.DT, method="delong")
roc.test.vali.RFvsSVM <- roc.test(roc.obj.vali.RF, roc.obj.vali.SVM, method="delong")
roc.test.vali.DTvsSVM <- roc.test(roc.obj.vali.DT, roc.obj.vali.SVM, method="delong")

# Display comparison results for training set
cat("On Training Set:\n")
cat("RF vs DT AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.train.RFvsDT$p.value), "\n\n")
cat("RF vs SVM AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.train.RFvsSVM$p.value), "\n\n")
cat("DT vs SVM AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.train.DTvsSVM$p.value), "\n\n")

# Display comparison results for test set
cat("On Test Set:\n")
cat("RF vs DT AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.test.RFvsDT$p.value), "\n\n")
cat("RF vs SVM AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.test.RFvsSVM$p.value), "\n\n")
cat("DT vs SVM AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.test.DTvsSVM$p.value), "\n\n")

# Display comparison results for validation set
cat("On Validation Set:\n")
cat("RF vs DT AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.vali.RFvsDT$p.value), "\n\n")
cat("RF vs SVM AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.vali.RFvsSVM$p.value), "\n\n")
cat("DT vs SVM AUC comparison:\n")
cat("p-value:", sprintf("%.3f", roc.test.vali.DTvsSVM$p.value), "\n\n")