#### Preamble ####
# Purpose: Simulates a dataset of marriage of USA
# Author: Xizi Sun
# Date: 24 November 2024
# Contact: xizi.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `here` package must be installed

#### Workspace setup ####
library(tidyverse)
library(here)

# Set the seed for reproducibility
set.seed(724)

# Number of observations
n <- 5000

# Simulate marital status (randomly generated)
marital_status <- sample(c("Married", "Not_Married"), size = n, replace = TRUE)

# Simulate age (randomly generated within a realistic range)
age <- sample(18:100, size = n, replace = TRUE)

# Simulate gender (randomly generated)
gender <- sample(c("Male", "Female"), size = n, replace = TRUE)

# Simulate race (randomly generated with no probabilities)
race <- sample(c("White", "Black", "Asian", "American Indian", "Other"), size = n, replace = TRUE)

# Simulate income (randomly generated within a realistic range)
income <- sample(15000:150000, size = n, replace = TRUE)

# Simulate education level (randomly generated from all categories)
education_level <- sample(c("Below_High_School", "High_School", "Some_College", "Bachelor", "Above_Bachelor"), 
                          size = n, replace = TRUE)

# Combine into a data frame
simulated_data <- data.frame(
  marital_status = marital_status,
  age = age,
  gender = gender,
  Race = race,
  Income = income,
  education_level = education_level
)

# Display the structure of the simulated dataset
str(simulated_data)

# Save the simulated data to a CSV file
write_csv(cleaned_data, here("data", "00-simulated_data", "simulated_data.csv"))

# Print a success message
cat("Simulation complete. Dataset with 5000 rows saved as 'simulated_data.csv'.\n")
