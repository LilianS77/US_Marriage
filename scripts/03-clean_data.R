#### Preamble ####
# Purpose: Cleans the raw data
# Author: Xizi Sun
# Date: 24 November 2024
# Contact: xizi.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `arrow`, `dplyr`,`fs` and `here` packages must be installed and loaded.
# Any other information needed? No.

# Load necessary libraries
library(dplyr)
library(here)
library(arrow)
library(fs)

# Step 1: Read the CSV file (adjust the path as necessary)
data <- read.csv(here("usa_00005.csv"))

# Step 2: Clean and process the data
cleaned_data <- data %>%
  # Select relevant columns
  select(MARST, SEX, AGE, RACE, EDUC, EMPSTAT, INCTOT) %>%
  
  # Remove invalid values based on codebook
  filter(
    MARST != 9,                # Remove missing marital status
    SEX %in% c(1, 2),          # Keep only valid genders (1 = Male, 2 = Female)
    AGE > 17 & AGE < 999,                 # Remove invalid ages
    RACE < 99,                 # Remove invalid race values
    EDUC %in% 0:11,            # Keep only valid education levels
    EMPSTAT < 9,               # Remove invalid employment status
    INCTOT < 9999999           # Remove invalid income
  ) %>%
  
  # Recode MARST into married and not married
  mutate(
    marital_status = if_else(MARST == 6, "Not_Married", "Married")
  ) %>%
  
  # Recode EDUC into education levels
  filter(!EDUC %in% c(0, 99)) %>%  # Remove invalid education values
  mutate(
    education_level = case_when(
      EDUC %in% c(0, 1, 2, 3, 4, 5) ~ "Below_High_School",  
      EDUC == 6 ~ "High_School",  
      EDUC %in% c(7, 8) ~ "Some_College",  
      EDUC == 10 ~ "Bachelor",  
      EDUC == 11 ~ "Above_Bachelor"  
    )
  ) %>%
  
  # Recode RACE into broader categories
  mutate(
    race_group = case_when(
      RACE == 1 ~ "White",
      RACE == 2 ~ "Black",
      RACE == 3 ~ "American Indian",
      RACE %in% c(7, 8, 9) ~ "Other",
      RACE %in% c(4, 5, 6) ~ "Asian"
    )
  ) %>%
  
  # Recode SEX into Male and Female
  mutate(
    gender = case_when(
      SEX == 1 ~ "Male",
      SEX == 2 ~ "Female"
    )
  )

# Step 3: Randomly sample 5,000 rows
set.seed(724)  # Ensure reproducibility
analysis_data <- cleaned_data %>%
  slice_sample(n = 5000) %>%  # Randomly sample 5,000 rows
  rename(
    Income = INCTOT,          # Rename INCTOT to Income
    Race = race_group         # Rename race_group to Race
  ) %>%
  select(marital_status, AGE, gender, Race, Income, education_level) %>%  # Select only the specified columns
  rename(age = AGE)  # Rename AGE to age for consistency


# Save the cleaned data
output_path <- here("data", "01-analysis_data", "analysis_data.parquet")
write_parquet(analysis_data, output_path)

# Save as CSV file
write_csv(analysis_data, here::here("data", "01-analysis_data", "analysis_data.csv"))

# Display the first few rows of cleaned data
head(analysis_data)

