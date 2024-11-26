#### Preamble ####
# Purpose: Build a Logistic Regression Model to assess the likelihood of an individual not being married (outcome variable)
# Author: Xizi Sun
# Date: 24 November 2024
# Contact: xizi.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `rstanarm`, `arrow` and `here` package must be installed


#### Workspace setup ####
# Load required libraries
library(tidyverse)
library(rstanarm)
library(arrow)
library(here)

#### Read the data and create model ####
# Read the cleaned analysis dataset
data <- read_parquet(here("data", "01-analysis_data", "analysis_data.parquet"))

# Ensure the marital_status variable is converted to a binary response variable
analysis_data <- data %>%
  mutate(Not_Married = ifelse(marital_status == "Not_Married", 1, 0))

# Fit a Bayesian logistic regression model
bayesian_model <- stan_glm(
  Not_Married ~ age + gender + Race + Income + education_level,
  data = analysis_data,
  family = binomial(link = "logit"),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  cores = 4,
  adapt_delta = 0.99,
  seed = 724
)

#### Save model ####
saveRDS(
  bayesian_model,
  file = "models/bayesian_model.rds"
)

