#### Preamble ####
# Purpose: Cleans the raw data
# Author: Xizi Sun
# Date: 24 November 2024
# Contact: xizi.sun@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `dplyr` and `here` packages must be installed and loaded.
# Any other information needed? No.

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(here)

#### Clean data ####
raw_data <- read_csv("/Users/XiziS/OneDrive/Desktop/1/US_Marriage/usa_00005.csv")

# Clean the data
cleaned_data <- raw_data %>%
  select(MARST, SEX, AGE, RACE, EDUCD, EMPSTAT, INCTOT) %>%
  filter(
    MARST != 9,
    SEX != 9,
    AGE < 999,
    RACE < 99,
    EDUCD < 999,
    EMPSTAT < 9,
    INCTOT < 9999999
  )

# Randomly sample data
set.seed(724)
analysis_data <- cleaned_data %>%
  slice_sample(n = 5000)

#### Save data ####
# Save cleaned data
write_csv(analysis_data, here::here("data", "analysis_data", "analysis_data.csv"))
output_path <- here("data", "01-analysis_data", "analysis_data.parquet")
write_parquet(analysis_data, output_path)

