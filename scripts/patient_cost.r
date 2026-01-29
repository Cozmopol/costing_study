library(dplyr)
library(purrr)
library(tibble)

# Minimum monthly wage in 2025 survey 14427
mon_min_wage <- 14427

# Monthly work hrs
mon_work_hrs <- 8 * 22

# Minimum hourly wage
hr_min_wage_ksh <- mon_min_wage / mon_work_hrs

# Minimum hourly wage in USD
# 1 USD = 128
hr_min_wage_usd <- hr_min_wage_ksh / 128

# ----------------------- Begin analysis ----------------------- #
# List columns with their respective col number
# for (i in seq_len(ncol(patient_costing))) {
#   cat(i, names(patient_costing)[i], "\n")
# }

# Create groups of costing
groups <- list(
  initial_visit = list(
    direct_costs = 22:26,
    non_health_transport = c(20, 46),
    non_health_food = c(39, 47),
    non_health_other = 40:42,
    `indirect_costs(min)` = c(15:16, 18:19)
  ),
  outpatient_visit = list(
    direct_costs = c(212:235, 245:268),
    non_health_transport = c(281:284, 286:289),
    non_health_food = 290:293,
    non_health_other = 294:297,
    `indirect_costs(min)` = c(208:211, 277:280, 306:309)
  ),
  inpatient_visit = list(
    direct_costs = 482:505,
    non_health_transport = c(518:521, 523:526),
    non_health_food = c(527:530),
    non_health_other = c(531:538),
    `indirect_costs(min)` = c(478:481, 514:517, 547:550)
  ),
  diagnosis = list(
    direct_costs = 511
  )
)

# Quality control for non-numeric columns
# Subset the group columns
cost_cols <- groups |>
  unlist(recursive = TRUE, use.names = FALSE) |>
  unique()

# Capture conversion issues
conversion_issues <- patient_costing |>
  select(all_of(cost_cols)) |>
  mutate(
    row_id = row_number()
  ) |>
  pivot_longer(
    -row_id,
    names_to = "column",
    values_to = "original_value"
  ) |>
  mutate(
    numeric_value = suppressWarnings(as.numeric(original_value)),
    failed = is.na(numeric_value) & !is.na(original_value)
  ) |>
  filter(failed)

# Log the issues
# There are none so far
write.csv(
  conversion_issues,
  file = "./logs/numeric_conversion_failures.csv",
  row.names = FALSE
)

# Convert non-numeric columns to numeric
patient_costing_clean <- patient_costing |>
  mutate(
    across(
      all_of(cost_cols),
      ~ as.numeric(.x)
    )
  )


# Sum the costs for each group
patient_costing_summary <- patient_costing_clean |>
  bind_cols(
    imap_dfc(groups, \(visit_groups, visit_name) {

      cols <- unlist(visit_groups)

      tibble(
        !!paste0("sum_", visit_name) :=
          rowSums(patient_costing[, cols, drop = FALSE], na.rm = TRUE)
      )
    })
  )

# Subset the relevant columns
patient_costing_1 <- patient_costing_summary |>
  select(record_id, gender, p_age, name_of_facility, starts_with("sum_"))

write.csv(
  patient_costing_1,
  file = "./results/patient_costing_summary.csv",
  row.names = FALSE
)
