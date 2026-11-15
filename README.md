# Roche-ADS-Task
```
Roche-ADS_Task/
│
├── README.md
│
├── question_1_R_package_development/
├── README.md
│   └── descriptiveStats/
│       ├── DESCRIPTION
│       ├── NAMESPACE
│       ├── R/
│       │   └── [R function files]
│       ├── man/
│       │   └── [Roxygen2 documentation]
│       └── tests/
│           └── testthat/
│               └── test-calc_mean.R
│
├── question_2_sdtm/
│   └── 02_create_ds_domain.R
│
├── question_4_tlg/
│   ├── [AE summary table script]
│   ├── [AE visualisation script]
│   ├── [AE listing script]
│   └── [Generated HTML and PNG outputs]
│
└── question_6_clinical_data_assistant/
    ├── [Clinical data agent implementation]
    └── tests/
        └── test_clinical_agent.py
```

# Question 1

### descriptiveStats Package
The descriptiveStats package provides simple functions for calculating common descriptive statistics from numeric vectors in R.

The package includes functions to calculate:

- Arithmetic mean
- Median
- Mode
- First Quartile
- Third Quartile
- Inter-quartile range

## Installation

You can install the development version of `descriptiveStats` from GitHub using `devtools`:

```{r eval=FALSE}
# Install devtools if you haven't already
install.packages("devtools")

# Install descriptiveStats
devtools::install_github("J3MWilliams/Roche-ADS-Task/question_1_R_package_development/descriptiveStats")
```
## Functions

### Arithmetic Mean

Calculates the arithmetic mean of a numeric vector by dividing the sum of its values by the number of observations.

The `calc_mean()` function:

- Accepts a numeric vector.
- Removes missing (`NA`) values before calculating the mean.
- Returns an error if the input is empty or contains only missing values.
- Returns an error if the input is not numeric.
- Produces a warning if the input contains only one observation.

```{r}
data <- c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)

calc_mean(data)
# [1] 4.3
```

#### Handling Missing Values

Missing values (`NA`) are automatically removed before the mean is calculated.

```{r}
data <- c(1, 2, 3, NA, 4, 5)

calc_mean(data)
# [1] 3
```

#### Error Handling

The function checks the input to ensure it meets the required conditions.

```{r eval=FALSE}
# Empty vector
calc_mean(numeric(0))

# Non-numeric input
calc_mean("hello")

# Vector containing only missing values
calc_mean(c(NA, NA))
```

A warning is generated when the input contains only one observation:

```{r}
calc_mean(5)
# [1] 5
# Warning: Input contains only one observation.
```

### Mode

Calculates the mode of a numeric vector. The mode is the value that occurs most frequently in a dataset.

The `calc_mode()` function:

- Accepts a numeric vector.
- Removes missing (`NA`) values before calculating the mode.
- Identifies the frequency of each unique value.
- Returns the most frequently occurring value if there is a single mode.
- Returns a vector of values if multiple modes exist.
- Returns `"No mode"` if no value occurs more than once.
- Returns an error if the input is empty, non-numeric, or contains only missing values.
- Produces a warning if the input contains only one observation.

#### Example: Single Mode

```{r}
data <- c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)

calc_mode(data)
# [1] 5
```

#### Example: Multiple Modes

If two or more values occur with the same highest frequency, the function returns all modes.

```{r}
data <- c(1, 2, 2, 3, 3, 4, 5)

calc_mode(data)
# [1] 2 3
```

#### Example: No Mode

If every value occurs only once, the function returns `"No mode"`.

```{r}
data <- c(1, 2, 3, 4, 5, 6)

calc_mode(data)
# [1] "No mode"
```

#### Handling Missing Values

Missing values (`NA`) are automatically removed before calculating the mode.

```{r}
data <- c(1, 2, 2, 3, NA, 4, 5)

calc_mode(data)
# [1] 2
```

#### Error Handling

The function checks the input to ensure it meets the required conditions.

```{r eval=FALSE}
# Empty vector
calc_mode(numeric(0))

# Non-numeric input
calc_mode("hello")

# Vector containing only missing values
calc_mode(c(NA, NA))
```

A warning is generated when the input contains only one observation:

```{r}
calc_mode(5)
# [1] 5
# Warning: Input contains only one observation.
```

### Median

Calculates the median of a numeric vector. The median represents the middle value of an ordered dataset, dividing the observations into two equal halves.

The `calc_median()` function:

- Accepts a numeric vector.
- Removes missing (`NA`) values before calculating the median.
- Sorts the observations into ascending order.
- Returns the middle value when the number of observations is odd.
- Calculates the average of the two middle values when the number of observations is even.
- Returns a numeric value.
- Returns an error if the input is empty, non-numeric, or contains only missing values.
- Produces a warning if the input contains only one observation.

#### Example

```{r}
data <- c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)

calc_median(data)
# [1] 4.5
```

#### Example: Odd Number of Observations

When the vector contains an odd number of observations, the function returns the middle value.

```{r}
data <- c(1, 2, 3, 4, 5)

calc_median(data)
# [1] 3
```

#### Example: Even Number of Observations

When the vector contains an even number of observations, the function calculates the average of the two middle values.

```{r}
data <- c(1, 2, 3, 4, 5, 6)

calc_median(data)
# [1] 3.5
```

#### Handling Missing Values

Missing values (`NA`) are automatically removed before calculating the median.

```{r}
data <- c(1, 2, 3, NA, 4, 5, 6)

calc_median(data)
# [1] 3.5
```

#### Error Handling

The function checks the input to ensure it meets the required conditions.

```{r eval=FALSE}
# Empty vector
calc_median(numeric(0))

# Non-numeric input
calc_median("hello")

# Vector containing only missing values
calc_median(c(NA, NA))
```

A warning is generated when the input contains only one observation:

```{r}
calc_median(5)
# [1] 5
# Warning: Input contains only one observation.
```

### First Quartile (Q1)

Calculates the first quartile (Q1) of a numeric vector. The first quartile represents the 25th percentile of the data, meaning that approximately 25% of observations fall at or below this value.

The `calc_q1()` function:

- Accepts a numeric vector.
- Removes missing (`NA`) values before calculating the quartile.
- Sorts the observations into ascending order.
- Calculates the position of the first quartile using linear interpolation.
- Returns a numeric value.
- Returns an error if the input is empty, non-numeric, or contains only missing values.
- Produces a warning if the input contains only one observation.

#### Example

```{r} id="q1ex01"
data <- c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)

calc_q1(data)
# [1] 2.5
```

#### Handling Missing Values

Missing values (`NA`) are automatically removed before calculating the first quartile.

```{r} id="q1ex02"
data <- c(1, 2, 3, NA, 4, 5, 6)

calc_q1(data)
```

#### Error Handling

The function checks the input to ensure it meets the required conditions.

```{r eval=FALSE} 
# Empty vector
calc_q1(numeric(0))

# Non-numeric input
calc_q1("hello")

# Vector containing only missing values
calc_q1(c(NA, NA))
```

A warning is generated when the input contains only one observation:

```{r}
calc_q1(5)
# [1] 5
# Warning: Input contains only one observation.
```

### Third Quartile (Q3)

Calculates the third quartile (Q3) of a numeric vector. The third quartile represents the 75th percentile of the data, meaning that approximately 75% of observations fall at or below this value.

The `calc_q3()` function:

- Accepts a numeric vector.
- Removes missing (`NA`) values before calculating the quartile.
- Sorts the observations into ascending order.
- Calculates the position of the third quartile using linear interpolation.
- Returns a numeric value.
- Returns an error if the input is empty, non-numeric, or contains only missing values.
- Produces a warning if the input contains only one observation.

#### Example

```{r} 
data <- c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)

calc_q3(data)
# [1] 5.5
```

#### Handling Missing Values

Missing values (`NA`) are automatically removed before calculating the third quartile.

```{r}
data <- c(1, 2, 3, NA, 4, 5, 6)

calc_q3(data)
```

#### Error Handling

The function checks the input to ensure it meets the required conditions.

```{r eval=FALSE}
# Empty vector
calc_q3(numeric(0))

# Non-numeric input
calc_q3("hello")

# Vector containing only missing values
calc_q3(c(NA, NA))
```

A warning is generated when the input contains only one observation:

```{r}
calc_q3(5)
# [1] 5
# Warning: Input contains only one observation.
```

#### Relationship with Other Quartile Functions

The third quartile can be used alongside the first quartile to calculate the interquartile range (IQR).

```{r}
calc_q1(data)
calc_q3(data)
calc_iqr(data)
```

### Interquartile Range (IQR)

Calculates the interquartile range (IQR) of a numeric vector. The IQR measures the spread of the middle 50% of the data and is calculated as the difference between the third quartile (Q3) and the first quartile (Q1).

The `calc_iqr()` function:

- Accepts a numeric vector.
- Sorts the observations into ascending order.
- Removes missing (`NA`) values before calculating the quartiles.
- Calculates Q1 (25th percentile) and Q3 (75th percentile) using linear interpolation.
- Calculates the IQR by subtracting Q1 from Q3.
- Returns an error if the input is empty, non-numeric, or contains only missing values.
- Produces a warning if the input contains only one observation.

```{r}
data <- c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)

calc_iqr(data)
# [1] 2.75
```

#### Handling Missing Values

Missing values (`NA`) are automatically removed before calculating the interquartile range.

```{r}
data <- c(1, 2, 3, NA, 4, 5, 6)

calc_iqr(data)
```

#### Error Handling

The function checks the input to ensure it meets the required conditions.

```{r eval=FALSE}
# Empty vector
calc_iqr(numeric(0))

# Non-numeric input
calc_iqr("hello")

# Vector containing only missing values
calc_iqr(c(NA, NA))
```

A warning is generated when the input contains only one observation:

```{r}
calc_iqr(5)
# [1] 0
# Warning: Input contains only one observation.
```

# Question 2
## SDTM Creation – Disposition (DS) Domain

This R programme creates the SDTM Disposition (DS) domain using raw disposition data from the `pharmaverseraw` package.

The programme uses the `sdtm.oak` package to perform variable mapping, controlled terminology application, date conversions, and derivation of SDTM variables.

**Expected output:** An SDTM DS dataset containing the following 12 variables:

`STUDYID`, `DOMAIN`, `USUBJID`, `DSSEQ`, `DSTERM`, `DSDECOD`, `DSCAT`, `VISITNUM`, `VISIT`, `DSDTC`, `DSSTDTC`, `DSSTDY`.

## Requirements

### R Packages

- `sdtm.oak`
- `pharmaverseraw`
- `tidyverse`

### Input Data

1. **Raw disposition data:** `ds_raw`, provided by the `pharmaverseraw` package.
2. **Controlled terminology:** `sdtm_ct.csv`, available from the [Pharmaverse examples repository](https://github.com/pharmaverse/examples/blob/main/metadata/sdtm_ct.csv).

## Programme Workflow

### 1. Programme Setup

Load the required packages and import the raw disposition data and controlled terminology file.

### 2. SDTM Setup

- Generate OAK identifier variables using `generate_oak_id_vars()`.
- Remove leading and trailing whitespace from character variables.
- Convert empty character values to missing values (`NA`).

### 3. Logic Indicators

Create two indicators to support conditional mapping:

- `is_other`: Identifies records where `OTHERSP` is populated.
- `is_rand`: Identifies randomized records where `OTHERSP` is missing.

### 4. Variable Mapping

Map the raw disposition variables to the corresponding SDTM variables:

| Target Variable | Source Variable | Mapping |
|---|---|---|
| DSSTDTC | IT.DSSTDAT | Convert to ISO 8601 |
| DSDECOD | IT.DSDECOD | Controlled terminology mapping |
| DSCAT | IT.DSDECOD | PROTOCOL MILESTONE or DISPOSITION EVENT |
| DSDECOD | OTHERSP | Map reported other event |
| DSCAT | OTHERSP | Assign OTHER EVENT |
| DSTERM | IT.DSTERM | Map reported disposition term |
| DSTERM | OTHERSP | Map reported other event |
| DSDTC | DSDTCOL, DSTMCOL | Convert date and time to ISO 8601 |
| VISIT | INSTANCE | Controlled terminology mapping |
| VISITNUM | INSTANCE | Controlled terminology mapping |

Additional variables are derived as follows:

- `STUDYID`: Mapped from `STUDY`.
- `DOMAIN`: Hardcoded as `"DS"`.
- `USUBJID`: Derived by concatenating `"01-"` with `PATNUM`.

### 5. Derivation of Additional Variables

**RFSTDTC**

The reference start date is derived as the earliest non-missing `DSSTDTC` associated with a randomized event (`DSDECOD = "RANDOMIZED"`) for each subject.

**DSSEQ**

Sequence numbers are generated using `derive_seq()`, ordered by `USUBJID`, `DSSTDTC`, and `VISITNUM`.

**DSSTDY**

Study day is derived using `derive_study_day()`, with `DSSTDTC` as the event date and `RFSTDTC` as the reference date.

The standard SDTM study day convention is applied:

- Dates on or after the reference date: `Event Date - Reference Date + 1`.
- Dates before the reference date: `Event Date - Reference Date`.

## Final Output

The final dataset is named `ds` and contains the following variables:

1. STUDYID
2. DOMAIN
3. USUBJID
4. DSSEQ
5. DSTERM
6. DSDECOD
7. DSCAT
8. VISITNUM
9. VISIT
10. DSDTC
11. DSSTDTC
12. DSSTDY

Date/time variables are retained as character variables to preserve ISO8601 formatting.

**Output dataset:** `ds`  
**Target domain:** SDTM DS (Disposition)  
**Number of variables:** 12

# Question 4

## TLG – Adverse Events Reporting

The objective is to summarize treatment-emergent adverse events (TEAEs), visualize AE distributions, and generate a detailed adverse event listing.

## Input Data

The following datasets are used:

- `pharmaverseadam::adae` – Adverse Events Analysis Dataset.
- `pharmaverseadam::adsl` – Subject-Level Analysis Dataset.

## Required R Packages

- `tidyverse`
- `pharmaverseadam`
- `gtsummary`
- `gt`
- `ggplot2`

## Deliverables

The task is divided into three R scripts.

### 1. Adverse Events Summary Table

**Script:** `01_create_ae_summary_table.R`

Creates a hierarchical summary table of treatment-emergent adverse events.

**Methodology:**

- Filter ADAE for treatment-emergent events (`TRTEMFL == "Y"`).
- Summarize adverse events by System Organ Class (`AESOC`) and Adverse Event Term (`AETERM`).
- Present results by actual treatment group (`ACTARM`).
- Calculate subject counts (n) and percentages (%).
- Use ADSL for subject-level denominators.
- Include an overall column covering all subjects.
- Sort AESOC alphabetically and AETERM by descending frequency.
- Generate the table using `gtsummary::tbl_hierarchical()`.

**Output:** `ae_summary_table.html`

### 2. Adverse Events Visualizations

**Script:** `02_create_visualizations.R`

Creates two graphical summaries using `ggplot2`.

**Plot 1: AE Severity Distribution by Treatment**

- Display AE severity (`AESEV`) across treatment groups (`ACTARM`).
- Use a stacked bar chart to show AE counts by severity.
- Compare severity distributions between treatment groups.

**Output:** `plt_1.png`

**Plot 2: Top 10 Most Frequent Adverse Events**

- Identify the 10 most frequently reported adverse events using `AETERM`.
- Count unique subjects experiencing each event.
- Calculate incidence percentages using the total number of unique subjects.
- Calculate exact 95% Clopper-Pearson confidence intervals using `binom.test()`.
- Display percentages and confidence intervals using points and horizontal error bars.

**Output:** `plt_2.png`

### 3. Adverse Events Listing

**Script:** `03_create_listings.R`

Creates a detailed listing of treatment-emergent adverse events.

**Methodology:**

- Filter ADAE for treatment-emergent events (`TRTEMFL == "Y"`).
- Exclude screening failure patients (`SCRFDT` is missing).
- Sort records by subject ID (`USUBJID`), event start date (`ASTDT`), and sequence number (`AESEQ`).
- Include the following variables:

| Variable | Description |
|---|---|
| USUBJID | Unique Subject Identifier |
| ACTARM | Actual Treatment |
| AETERM | Adverse Event Term |
| AESEV | Adverse Event Severity |
| AEREL | Relationship to Drug |
| ASTDT | Adverse Event Start Date |
| AENDT | Adverse Event End Date |

- Apply descriptive column labels and table formatting using `gt`.
- Include a title and subtitle identifying the listing population.

**Output:** `ae_listings.html`

## Folder Structure

```text
question_4_tlg/
│
├── 01_create_ae_summary_table.R
├── 02_create_visualizations.R
├── 03_create_listings.R
│
├── ae_summary_table.html
├── ae_listings.html
├── plt_1.png
└── plt_2.png
```

**Question:** 4 – TLG: Adverse Events Reporting

**Scripts:** 3 R scripts  
**Deliverables:** 1 HTML summary table, 2 PNG visualizations, and 1 HTML listing.

# Question 6

# Question 6: Clinical Trial Data Assistant

## 1. Objective

Develop a Generative AI-powered Clinical Trial Data Assistant that translates natural language questions into structured Pandas queries.

The assistant enables clinical safety reviewers to query Adverse Events (AE) clinical trial data using natural language without needing to know the underlying dataset column names.

The solution uses a Large Language Model (LLM) to understand user intent, identify the relevant dataset variable, extract the requested filter value, and generate structured JSON output that is subsequently executed against the clinical dataset using Pandas.

## 2. Scenario

A clinical safety reviewer wants to ask free-text questions about the Adverse Events (AE) dataset.

The reviewer may not know the technical variable names used in the dataset. The assistant must understand the question and dynamically identify the appropriate variable based on the dataset schema.

Examples:

| Natural Language Query | Target Column | Filter Value |
|---|---|---|
| Show me all severe adverse events | `AESEV` | Severe |
| Find patients who experienced Headache | `AETERM` | Headache |
| Show adverse events related to Cardiac conditions | `AESOC` | Cardiac |

The mapping must be performed through LLM-based interpretation rather than hard-coded keyword rules.

## 3. Dataset

**Input file:** `adae.csv`

**Source:** `pharmaversesdtm::ae`

The dataset contains clinical trial adverse event information.

The data dictionary is provided to the LLM to support accurate identification of the relevant variables.

## 4. Project Structure

```text
Question-6-Clinical-Data-Assistant/
│
├── requirements.txt
│
├── data/
│   └── adae.csv
│
├── src/
│   └── clinical_agent.py
│
└── tests/
    └── test_clinical_agent.py
```

## 5. Solution Architecture

The application follows a three-stage workflow:

### Stage 1: Prompt

The user submits a natural language question.

Examples:
- Give me all severe adverse events.
- Find subjects who experienced Headache.
- Show me adverse events associated with Cardiac conditions.

The agent provides the LLM with:
- The user's question.
- The clinical dataset schema.
- Instructions for identifying the correct target column.
- Instructions to extract the filter value.
- A requirement to return structured JSON.

### Stage 2: Parse

The LLM interprets the question and generates a structured JSON response.

Expected JSON structure:

```json
{
    "target_column": "AESEV",
    "filter_value": "Severe"
}
```

Another example:

```json
{
    "target_column": "AETERM",
    "filter_value": "Headache"
}
```

The agent validates the generated output before executing the query.

### Stage 3: Execute

The structured JSON response is passed to the Pandas execution function.

The function:
1. Identifies the target column.
2. Applies the requested filter to the AE dataframe.
3. Retrieves matching adverse event records.
4. Counts the unique subjects using `USUBJID`.
5. Returns the unique subject count and matching subject IDs.

The overall workflow is:

```text
User Natural Language Question
              |
              v
       LLM Prompt
              |
              v
     Dataset Schema
              |
              v
       LLM Parsing
              |
              v
    Structured JSON Output
              |
              v
      JSON Validation
              |
              v
      Pandas Filtering
              |
              v
    Matching AE Records
              |
              v
    Unique Subject Count
              |
              v
       Matching IDs
```

## 6. Implementation

### Main Application

**File:** `src/clinical_agent.py`

The main application implements the `ClinicalTrialDataAgent` class.

Its responsibilities include:

- Loading the ADAE dataset.
- Defining the clinical dataset schema.
- Creating the LLM prompt.
- Interpreting natural language questions.
- Generating structured JSON output.
- Validating the target column and filter value.
- Executing Pandas filters.
- Returning unique subject counts and matching subject IDs.

### LLM Integration

The application can use an OpenAI model through LangChain or an alternative LLM solution.

An API key can be configured through an environment variable.

If an API key is unavailable, a mocked LLM response can be used to demonstrate the complete workflow:

**Prompt → Parse → Execute**

The mocked implementation should preserve the same structured JSON interface as the actual LLM implementation.

## 7. Installation and Setup

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd Question-6-Clinical-Data-Assistant
```

### Step 2: Create a Virtual Environment

```bash
python -m venv venv
```

Activate the environment.

**Windows:**

```bash
venv\Scripts\activate
```

**macOS/Linux:**

```bash
source venv/bin/activate
```

### Step 3: Install Dependencies

```bash
pip install -r requirements.txt
```

### Step 4: Configure API Key (If Using OpenAI)

Set the OpenAI API key as an environment variable.

**Windows PowerShell:**

```powershell
$env:OPENAI_API_KEY="your-api-key"
```

**macOS/Linux:**

```bash
export OPENAI_API_KEY="your-api-key"
```

If using a mocked LLM implementation, an API key is not required.

## 8. Running the Application

From the project root directory, execute:

```bash
python src/clinical_agent.py
```

Ensure the `adae.csv` file is available in the `data/` directory.

## 9. Testing

**Test file:** `tests/test_clinical_agent.py`

The test script demonstrates the assistant using three example natural language queries.

Example queries:

1. "Give me all severe adverse events."
2. "Find patients who experienced Headache."
3. "Show me adverse events associated with Cardiac conditions."

For each query, the application should:

- Interpret the natural language question.
- Identify the appropriate target column.
- Extract the filter value.
- Generate structured JSON output.
- Execute the corresponding Pandas filter.
- Return the number of unique subjects.
- Display the matching subject IDs.

### Run the Test Script

```bash
python tests/test_clinical_agent.py
```

## 10. Expected Output

The output for each query should include:

```text
User Question:
Give me all severe adverse events.

LLM Structured Output:
{
    "target_column": "AESEV",
    "filter_value": "Severe"
}

Execution Results:
Unique Subject Count: <calculated count>

Matching Subject IDs:
<list of matching USUBJID values>
```

The actual counts and subject IDs are calculated dynamically from the supplied dataset.
## 11. Design Considerations

- The assistant should dynamically identify dataset variables using the LLM rather than relying on hard-coded keyword mappings.
- Only valid dataset columns should be accepted as target columns.
- Invalid or incomplete LLM responses should be handled appropriately.
- Subject counts should use unique `USUBJID` values to avoid duplicate subject counting.
- The solution should support both actual LLM integration and mocked LLM responses.
- Clinical data outputs should be validated before being used in clinical or regulatory decision-making.

## 12. Deliverables

The project includes the following deliverables:

1. **Solution Code:** `src/clinical_agent.py`
   - Implements the ClinicalTrialDataAgent.
   - Handles LLM prompting and structured JSON parsing.
   - Executes Pandas filters against the ADAE dataset.
   - Returns unique subject counts and matching IDs.

2. **Test Script:** `tests/test_clinical_agent.py`
   - Executes three example natural language queries.
   - Demonstrates the Prompt → Parse → Execute workflow.
   - Prints the results for each query.

3. **Dependencies:** `requirements.txt`
   - Lists the Python packages required to run the application.

4. **Dataset:** `data/adae.csv`
   - Contains the clinical adverse events data used for analysis.
