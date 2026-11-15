# SDTM Creation
# Expected Result: 
# Error free program with good documentation that will create the DS domain 
# with the following variables 
# STUDYID, DOMAIN, USUBJID, DSSEQ, DSTERM, DSDECOD, DSCAT, VISITNUM, 
# VISIT, DSDTC, DSSTDTC, DSSTDY 

# PROG. SET UP ------------------------------------------------------------

# Call packages
library(sdtm.oak)
library(pharmaverseraw)

library(tidyverse)

# Import data
# Downloaded from Github: 
# https://github.com/pharmaverse/examples/blob/main/metadata/sdtm_ct.csv

study_ct <- read.csv("sdtm_ct.csv")      

ds_raw <- pharmaverseraw::ds_raw


# SDTM SET UP -------------------------------------------------------------

ds_raw <- ds_raw %>%
  generate_oak_id_vars(pat_var = "PATNUM",
                       raw_src = "ds_raw") %>%
  mutate(across(where(is.character), ~ na_if(trimws(.x), "")))

# Get ct_clst from study_ct
i_ct_clst <- study_ct %>%
  filter(collected_value %in% unique(ds_raw$IT.DSDECOD)) %>%
  distinct(codelist_code) %>%
  pull(codelist_code)

# LOGIC INDICATORS --------------------------------------------------------
# For IT.DSDECOD mapping requirements
ds_raw <- ds_raw %>%
  mutate(
    is_other = !is.na(OTHERSP), # TRUE if not null
    is_rand  = !is_other & IT.DSDECOD == "Randomized") # TRUE if randomized

# MAP VARS ----------------------------------------------------------------
#   Number corresponds to the order of the`General Notes` in this pdf file:
#   https://github.com/pharmaverse/pharmaverseraw/blob/main/vignettes/articles/aCRFs/Subject_Disposition_aCRF.pdf 

ds <- 
  # 1. IT.DSSDAT to DSSTDTC, ISO8601 format
  assign_datetime(raw_dat = ds_raw,
                  raw_var = "IT.DSSTDAT",
                  tgt_var = "DSSTDTC",
                  raw_fmt = "m-d-y",
                  id_vars = oak_id_vars()) %>%
  
  # 2. OTHERSP is null, map IT.DSDECOD to DSDECOD
  # using indicator is_other
  assign_ct(raw_dat = condition_add(ds_raw, !is_other),
            raw_var = "IT.DSDECOD",
            tgt_var = "DSDECOD",
            ct_spec = study_ct,
            ct_clst = i_ct_clst,
            id_vars = oak_id_vars()) %>%
  
  # 3. If IT.DSDECOD = Randomized then map DSCAT = PROTOCOL MILESTONE 
  # using indicator is_rand
  hardcode_no_ct(raw_dat = condition_add(ds_raw, is_rand),
                 raw_var = "IT.DSDECOD",
                 tgt_var = "DSCAT",
                 tgt_val = "PROTOCOL MILESTONE",
                 id_vars = oak_id_vars()) %>%
  
  # else DSCAT = DISPOSITION EVENT
  hardcode_no_ct(raw_dat = condition_add(ds_raw, !is_rand & !is_other),
                 raw_var = "IT.DSDECOD",
                 tgt_var = "DSCAT",
                 tgt_val = "DISPOSITION EVENT",
                 id_vars = oak_id_vars()) %>%
  
  # 4. If OTHERSP is not null then map the value in OTHERSP to DSDECOD and 
  #     also to DSTERM
  assign_no_ct(raw_dat = condition_add(ds_raw, is_other),
               raw_var = "OTHERSP",
               tgt_var = "DSDECOD",
               id_vars = oak_id_vars()) %>%
  
  # 5. If OTHERSP is not null then map DSCAT = OTHER EVENT
  hardcode_no_ct(raw_dat = condition_add(ds_raw, is_other),
                 raw_var = "OTHERSP",
                 tgt_var = "DSCAT",
                 tgt_val = "OTHER EVENT",
                 id_vars = oak_id_vars()) %>%
  
  # 6. If OTHERSP is null then map the value in IT.DSTERM to DSTERM
  assign_no_ct(raw_dat = condition_add(ds_raw, !is_other),
               raw_var = "IT.DSTERM",
               tgt_var = "DSTERM",
               id_vars = oak_id_vars()) %>%
  assign_no_ct(raw_dat = condition_add(ds_raw, is_other),
               raw_var = "OTHERSP",
               tgt_var = "DSTERM",
               id_vars = oak_id_vars()) %>%
  
  # 7. Map the value in DSDTCOL & DSTMCOL to DSDTC in ISO8601 format
  assign_datetime(raw_dat = ds_raw,
                  raw_var = c("DSDTCOL", "DSTMCOL"),
                  tgt_var = "DSDTC",
                  raw_fmt = c("m-d-y","H:M"),
                  id_vars = oak_id_vars()) 

# OTHER VARS --------------------------------------------------------------

ds <- ds %>%
  # VISIT
  assign_ct(raw_dat = ds_raw,
          raw_var = "INSTANCE",
          tgt_var = "VISIT",
          ct_spec = study_ct,
          ct_clst = "VISIT",
          id_vars = oak_id_vars()) %>%
  # VISITNUM
  assign_ct(raw_dat = ds_raw,
            raw_var = "INSTANCE",
            tgt_var = "VISITNUM",
            ct_spec = study_ct,
            ct_clst = "VISITNUM",
            id_vars = oak_id_vars()) %>%
  # STUDYID, DOMAIN, USUBJID, DSSTDTC, DSDTC
  left_join(select(ds_raw, oak_id, raw_source, patient_number, STUDY, PATNUM),
            by = c("oak_id", "raw_source", "patient_number")) %>%
  mutate(
    STUDYID = STUDY,
    DOMAIN = "DS",
    USUBJID = paste0("01-", PATNUM),
    VISITNUM = as.numeric(VISITNUM),
    DSSTDTC = as.character(DSSTDTC),   # keep ISO8601 as character
    DSDTC = as.character(DSDTC))


# DERIVE OTHER VARS -------------------------------------------------------

# Assumption: reference start date from ds_raw only, randomised record
ref_dates <- ds %>%
  filter(DSDECOD == "RANDOMIZED", !is.na(DSSTDTC)) %>%
  group_by(USUBJID) %>%
  summarise(RFSTDTC = min(DSSTDTC), .groups = "drop")


ds <- ds %>%
  arrange(USUBJID, DSSTDTC, VISITNUM) %>%
  derive_seq(tgt_var = "DSSEQ",
             rec_vars = c("USUBJID", "DSSTDTC", "VISITNUM")) %>%
  derive_study_day(sdtm_in = .,
                   dm_domain = ref_dates,     
                   tgdt = "DSSTDTC",
                   refdt = "RFSTDTC",
                   study_day_var = "DSSTDY")

# TIDY OUTPUT -------------------------------------------------------------

ds <- ds %>%
  mutate(DSSTDTC = as.character(DSSTDTC),
         DSDTC   = as.character(DSDTC)) %>%
  select(STUDYID, DOMAIN, USUBJID, DSSEQ, DSTERM, DSDECOD, DSCAT,
         VISITNUM, VISIT, DSDTC, DSSTDTC, DSSTDY)

