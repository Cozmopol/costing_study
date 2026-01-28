library(tidyverse)
library(readr)

# Get the current wd
getwd()

# Load the patient costing data
# It exists in your cwd in a folder called 'data
patient_costing <- read_csv(
  "./data/IHCoRPatientCostingT_DATA_2026-01-28_2054.csv"
)

# Explore the data
names(patient_costing)

# Check for duplicated record id
sum(duplicated(patient_costing$record_id))

# Participants not yet interviewd
sum(is.na(patient_costing$date_of_interview))
