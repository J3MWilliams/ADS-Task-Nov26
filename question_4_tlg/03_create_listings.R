# Create listings

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
  filter(is.na(SCRFDT),
         TRTEMFL == "Y") 

ae_listing <- adae %>%
  arrange(USUBJID, ASTDT, AESEQ) %>%
  select(
    USUBJID,
    ACTARM,
    AETERM,
    AESEV,
    AEREL,
    ASTDT,
    AENDT
  ) %>%
  gt() %>%
  cols_label(
    ACTARM = "Treatment",
    AETERM = "Adverse Event Term",
    AESEV  = "Severity",
    AEREL  = "Relationship to Drug",
    ASTDT  = "Start Date/Time of Adverse Event",
    AENDT  = "End Date/Time of Adverse Event"
  )  %>%
  tab_header(
    title = "Listing of Treatment-Emergent Adverse Events by Subject",
    subtitle = "Excluding Screen Failure Patients"
  ) %>%
  opt_row_striping() %>%
  # Convert to gt object and save to WD
  gtsave("ae_listings.html")
