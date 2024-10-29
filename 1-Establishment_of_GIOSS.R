library(readxl)
library(survival)
data <- read_excel("data_for_elderly_GC_based_on_GIOSS.xlsx")
str(data)

# Replace values based on the given thresholds
data$ALB <- ifelse(data$ALB >= 42.1, 1, 0)
data$TBIL <- ifelse(data$TBIL >= 8.3, 1, 0)
data$DBIL <- ifelse(data$DBIL >= 2.8, 1, 0)
data$BUN <- ifelse(data$BUN >= 4, 1, 0)
data$UA <- ifelse(data$UA >= 395, 1, 0)

# Check data structure to verify the transformation
str(data)

# Create a survival object
survival_obj <- Surv(time = data$OStime, event = data$OSstatus)

cox_analysis <- function(variable_name, data) {
  # Create a data frame containing only the specific variable
  cox_data <- data.frame(Variable = data[[variable_name]])
  
  # Perform Cox univariate regression analysis
  cox_model <- coxph(survival_obj ~ Variable, data = cox_data)
  
  # Get Cox regression results
  cox_summary <- summary(cox_model)
  
  # Extract p-value and HR
  p_value <- cox_summary$coefficients[, "Pr(>|z|)"]
  hazard_ratio <- exp(cox_summary$coefficients[, "coef"])
  hr_interval <- exp(confint(cox_model))  # Get HR confidence interval
  beta_coefficient <- cox_summary$coefficients[, "coef"]  # Get beta coefficient
  
  # Round to three decimal places
  p_value <- round(p_value, 3)
  hazard_ratio <- round(hazard_ratio, 3)
  hr_interval <- round(hr_interval, 3)
  beta_coefficient <- round(beta_coefficient, 3)
  
  # Print results
  result <- data.frame(Variable = variable_name, P_Value = p_value, HR = hazard_ratio, HR_95_CI_Lower = hr_interval[1], HR_95_CI_Upper = hr_interval[2], Beta_Coefficient = beta_coefficient)
  return(result)
}

# Perform analysis for each variable
result_ALB <- cox_analysis("ALB", data)
result_TBIL <- cox_analysis("TBIL", data)
result_DBIL <- cox_analysis("DBIL", data)
result_BUN <- cox_analysis("BUN", data)
result_UA <- cox_analysis("UA", data)

# Print results
print(result_ALB)
print(result_TBIL)
print(result_DBIL)
print(result_BUN)
print(result_UA)

# Combine results into one data frame
results <- rbind(result_ALB, result_TBIL, result_DBIL, result_BUN, result_UA)

# Filter variables with p-value less than 0.05
significant_vars <- results$Variable[results$P_Value < 0.05]

# Check if any variables meet the criteria
if (length(significant_vars) > 0) {
  # Create a formula for multivariate Cox regression using significant variables
  multivar_formula <- as.formula(paste("survival_obj ~", paste(significant_vars, collapse = " + ")))
  
  # Perform multivariate Cox regression analysis
  multivar_cox_model <- coxph(multivar_formula, data = data)
  
  # Get summary of the Cox model
  multivar_cox_summary <- summary(multivar_cox_model)
  
  # Print multivariate Cox regression results
  print(multivar_cox_summary)
} else {
  print("No variables with p-value less than 0.05 found for multivariate analysis.")
}
