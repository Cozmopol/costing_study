library(gtsummary)

# Build features incrementally
table1 <- patient_costing |>
    select("name_of_facility", "p_age", "gender", "place_of_diagnosis", "iv21a") |>
    mutate(gender = ifelse(gender == 1, "Male", "Female"),
           iv21a = ifelse(iv21a == 1, "Yes", "No"),
           place_of_diagnosis = case_when(
               place_of_diagnosis == 1 ~ "Government Hospital",
               place_of_diagnosis == 2 ~ "Government Health Centre",
               place_of_diagnosis == 3 ~ "Dispensary",
               place_of_diagnosis == 4 ~ "Community/Household",
               place_of_diagnosis == 5 ~ "Other"
           ))

# Check for normality of p_age
shapiro.test(table1$p_age)

# Create the summary table
table_1_summary <-  table1 |>
    tbl_summary(
        missing = "ifany",
        by = name_of_facility,
        statistic = list(all_continuous() ~ "{mean} ({sd})",
                         p_age ~ "{median} ({p25}, {p75})"),
        label = list(
            name_of_facility = "Location",
            p_age = "Median Age (years)",
            gender = "Sex",
            place_of_diagnosis = "Place of Diagnosis",
            iv21a = "Enrolled in insurance scheme"
        )
    ) |>
    add_overall(col_label = "All participants") # |>
    # To work on the confidence intervals later
    # add_ci(include = c("gender", "place_of_diagnosis", "iv21a"))

gt::gtsave(
    as_gt(table_1_summary),
    filename = "./results/table_1.docx"
)
