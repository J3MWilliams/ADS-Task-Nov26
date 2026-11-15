# Create visualisations

# Q4: TLG - Adverse Events Reporting

# SET UP ------------------------------------------------------------------

# Call required packages

library(tidyverse)
library(pharmaverseadam)
library(gtsummary)

# DATA PREPARATION --------------------------------------------------------

# Subset population of interest: TEAEs
adae <- pharmaverseadam::adae %>%
  filter(TRTEMFL == "Y")

# PLOT 1 ------------------------------------------------------------------
# AE Severity distribution (bar chart or heatmap)
# indicated by AESEV variable

plt_1 <- ggplot(adae,
                aes(x = ACTARM,
                    fill = AESEV)) +
  geom_bar(stat = "count") +
  labs(title = "AE severity distibution by treatment",
       x = "Treatment Arm",
       y = "Count of AEs") 

ggsave(plot = plt_1,
       "plt_1.png")


# PLOT 2 ------------------------------------------------------------------
# Top 10 most frequent AEs (with 95% CI for  incidence rates). AEs are 
# captured in the  AETERM  variable in  pharmaverseadam::adae  dataset.

n_total <- n_distinct(adae$USUBJID)

# Get top 10 most frequent
ae_10 <- adae %>%
  distinct(USUBJID, AETERM) %>% # per patient, per term
  count(AETERM, name = "n") %>%
  slice_max(n, 
            n = 10, 
            with_ties = FALSE) %>%
  # get CIs for incidence rates
  mutate(
    pct   = 100 * n / n_total,
    ci    = map(n, ~ binom.test(.x, 
                                n_total, 
                                conf.level = 0.95)$conf.int),
    lwr_ci = 100 * map_dbl(ci, 1),
    upr_ci = 100 * map_dbl(ci, 2)
  )

plt_2 <- ggplot(ae_10, 
                aes(x = pct, 
                    y = reorder(AETERM, pct))) +
  geom_errorbar(aes(xmin = lwr_ci, 
                    xmax = upr_ci),
                orientation = "y", 
                width = 0.25) +
  geom_point(size = 2.5) +
  labs(title = "Top 10 Most Frequent Adverse Events",
       subtitle = paste0("n = ", n_total, " subjects; 95% Clopper-Pearson CIs"),
       x = "Percentage of Patients (%)",
       y = NULL) 

ggsave(plot = plt_2,
       "plt_2.png")