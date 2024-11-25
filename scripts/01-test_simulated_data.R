#### Preamble ####
# Purpose: Tests the structure and validity of the simulated data
# Author: Xizi Sun
# Date: 24 November 2024
# Contact: xizi.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites:   
# - The `tidyverse`, `testthat`, `readr` and `here` packages must be installed and loaded.
# - 00-simulate_data.R must have been run
# Any other information needed? No

# Load necessary libraries
library(testthat)
library(validate)
library(readr)
library(here)

# Load the simulated dataset
simulated_data <- read_csv(here("data", "00-simulated_data", "simulated_data.csv"))

# Test Suite for Simulated Dataset using testthat
test_that("Simulated Dataset Variable-Level Tests", {
  
  # 1. Check if gender is a character
  expect_true(is.character(simulated_data$gender))
  
  # 2. Check if marital_status is a character and contains only expected values
  expect_true(is.character(simulated_data$marital_status))
  expect_true(all(simulated_data$marital_status %in% c("Married", "Not_Married")))
  
  # 3. Check if age is numeric and within the valid range
  expect_true(is.numeric(simulated_data$age))
  expect_true(all(simulated_data$age >= 18 & simulated_data$age <= 110))
  
  # 4. Check if Race is a character and contains only expected categories
  expect_true(is.character(simulated_data$Race))
  expect_true(all(simulated_data$Race %in% c("White", "Black", "Asian", "American Indian", "Other")))
  
  # 5. Check if Income is numeric and not empty (removed range test as per request)
  expect_true(is.numeric(simulated_data$Income))
  expect_true(!any(is.na(simulated_data$Income)))
  
  # 6. Check if education_level is a character and contains only expected categories
  expect_true(is.character(simulated_data$education_level))
  expect_true(all(simulated_data$education_level %in% c(
    "Below_High_School", "High_School", "Some_College", "Bachelor", "Above_Bachelor"
  )))
  
  # 7. Check if there are no duplicate rows in the dataset
  expect_true(nrow(simulated_data) == nrow(unique(simulated_data)))
  
  # 8. Check for missing values in all columns
  expect_true(all(complete.cases(simulated_data)))
})

# Additional Tests with validate
rules <- validator(
  # 9. Check that marital_status contains only "Married" or "Not_Married"
  marital_status_is_valid = all(simulated_data$marital_status %in% c("Married", "Not_Married")),
  
  # 10. Ensure age is numeric and falls between 18 and 110
  age_is_valid = all(simulated_data$age >= 18 & simulated_data$age <= 110),
  
  # 11. Ensure there are no missing values in the dataset
  no_missing_values = all(complete.cases(simulated_data)),
  
  # 12. Ensure education_level has only expected values
  education_is_valid = all(simulated_data$education_level %in% c(
    "Below_High_School", "High_School", "Some_College", "Bachelor", "Above_Bachelor"
  ))
)

# Apply the validation rules to the dataset
validation_results <- confront(simulated_data, rules)

# Print validation summary
cat("\nValidation Results:\n")
print(summary(validation_results))

# Visualize validation results (optional)
plot(validation_results)