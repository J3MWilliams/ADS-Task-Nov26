# Roche Senior ADS Programmer Candidate Task
# Jennifer Williams

# Q4: TLG - Adverse Events Reporting

# SET UP ------------------------------------------------------------------

# Call required packages

library(tidyverse)
library(pharmaverseadam)
library(gtsummary)
library(gt)

# DATA PREPARATION --------------------------------------------------------

# Subset population of interest: TEAEs
adae <- pharmaverseadam::adae %>%
  filter(TRTEMFL == "Y")

# Table:
# AETERM (Reported Term for the Adverse Event) 
# AESOC (Primary System Organ Class) 
# x ACTARM (Description of Actual Arm)

# Include:
# Count (%)
# Include total row with all subjects
# Descending frequency sort

# CREATE TABLE ------------------------------------------------------------

tbl <- adae %>%
  tbl_hierarchical(variables = c(AESOC, AETERM),
                   by = ACTARM,
                   id = USUBJID,
                   denominator = adsl,
                   overall_row = TRUE,
                   label = list(..ard_hierarchical_overall.. = "Treatment Emergent AEs")) %>%
  # Sort
  sort_hierarchical(sort = c(AESOC ~ "alphanumeric", 
                             AETERM ~ "descending")) %>%
  # Convert to gt object and save to WD
  as_gt() %>%
  gtsave("ae_summary_table.html")

