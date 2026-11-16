# Question 6
# Clinical Data Assistant

# Packages required
import os
import json
import pandas as pd

from pydantic import BaseModel, Field
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

# Data schema
# Data dictionary from pharmaverseadam::adae help documentation
data_dictionary = {

    # Subject identifiers
    "STUDYID": "Study Identifier",
    "USUBJID": "Unique Subject Identifier",
    "SUBJID": "Subject Identifier for the Study",
    "SITEID": "Study Site Identifier",
    "COUNTRY": "Country",

    # Demographics
    "AGE": "Subject Age",
    "AGEU": "Age Units",
    "AGEGR1": "Pooled Age Group",
    "SEX": "Subject Sex",
    "RACE": "Subject Race",
    "ETHNIC": "Subject Ethnicity",

    # Treatment
    "ARM": "Description of Planned Treatment Arm",
    "ARMCD": "Planned Treatment Arm Code",
    "ACTARM": "Description of Actual Treatment Arm",
    "ACTARMCD": "Actual Treatment Arm Code",
    "TRT01P": "Planned Treatment for Period 01",
    "TRT01A": "Actual Treatment for Period 01",

    # Adverse event identification
    "AESEQ": "Adverse Event Sequence Number",
    "AETERM": "Reported Term for the Adverse Event",
    "AEDECOD": "Dictionary-Derived Medical Term",

    # Body system and medical classification
    "AEBODSYS": "Body System or Organ Class",
    "AESOC": "Primary System Organ Class",
    "AELLT": "Lowest Level Term",
    "AEHLT": "High Level Term",
    "AEHLGT": "High Level Group Term",

    # Adverse event severity
    "AESEV": "Severity or Intensity",
    "ASEV": "Analysis Severity or Intensity",
    "ASEVN": "Numeric Analysis Severity",

    # Seriousness
    "AESER": "Serious Adverse Event",
    "AESDTH": "Adverse Event Resulted in Death",
    "AESLIFE": "Life-Threatening Adverse Event",
    "AESHOSP": "Adverse Event Required Hospitalisation",
    "AESDISAB": "Persistent or Significant Disability",
    "AESCONG": "Congenital Anomaly or Birth Defect",

    # Adverse event outcome and treatment relationship
    "AEOUT": "Outcome of Adverse Event",
    "AEREL": "Relationship to Study Treatment",
    "AREL": "Analysis Relationship to Treatment",
    "AEACN": "Action Taken with Study Treatment",

    # Other adverse event variables
    "TRTEMFL": "Treatment-Emergent Adverse Event Flag",
    "AOCCIFL": "First Maximum Severity Occurrence Flag",

    # Adverse event dates
    "AESTDTC": "Start Date of Adverse Event",
    "AEENDTC": "End Date of Adverse Event",
    "ASTDT": "Analysis Start Date",
    "AENDT": "Analysis End Date"

}

# Structured output
class ClinicalFilter(BaseModel):

    target_column: str = Field(
        description=(
            "The exact dataset column name selected "
            "from the supplied dataset schema."
        )
    )

    filter_value: str = Field(
        description=(
            "The clinical value, category or condition "
            "extracted from the user's question."
        )
    )


# Creating our agent

class ClinicalTrialDataAgent:

    def __init__(self, dataframe, use_mock=False):

        self.df = dataframe.copy()
        self.use_mock = use_mock

        # Standardise dataset column names
        self.df.columns = (
            self.df.columns.astype(str).str.strip().str.upper()
        )

        # Check required subject identifier
        if "USUBJID" not in self.df.columns:
            raise ValueError(
                "USUBJID column is missing from the dataset."
            )

        # Keep only schema columns present in the dataset
        self.schema = {
            column: description
            for column, description in data_dictionary.items()
            if column in self.df.columns
        }

        if not self.schema:
            raise ValueError(
                "No recognised dataset columns were found."
            )

        # Initialise LLM or MOCK mode
        if self.use_mock:

            self.llm = None

        else:

            api_key = os.getenv("OPENAI_API_KEY")

            if not api_key:
                raise ValueError(
                    "OPENAI_API_KEY is required for LLM mode."
                )

            self.llm = ChatOpenAI(
                model="gpt-4o-mini",
                temperature=0,
                api_key=api_key,
                max_retries=2
            ).with_structured_output(ClinicalFilter)

        # Define prompt template
        self.prompt = ChatPromptTemplate.from_messages([

            (
                "system",
                """
                You are an expert clinical trial data assistant.

                Your task is to translate natural-language questions
                into structured filters for a clinical adverse event
                dataset.

                DATASET SCHEMA:
                {schema}

                Use the descriptions to understand the meaning
                of each variable.

                COLUMN MAPPING GUIDANCE:

                - Severity or intensity:
                  AESEV or ASEV.

                - Serious adverse events:
                  AESER.

                - Adverse events resulting in death:
                  AESDTH.

                - Life-threatening adverse events:
                  AESLIFE.

                - Adverse events requiring hospitalisation:
                  AESHOSP.

                - Specific adverse event or medical condition:
                  AETERM.

                - Standardised medical condition:
                  AEDECOD.

                - Body system or organ class:
                  AESOC or AEBODSYS.

                - Adverse event outcome:
                  AEOUT.

                - Relationship to treatment:
                  AEREL or AREL.

                - Action taken with study treatment:
                  AEACN.

                - Treatment-emergent adverse events:
                  TRTEMFL.

                - Subject age:
                  AGE.

                - Subject sex:
                  SEX.

                - Subject country:
                  COUNTRY.

                - Treatment group:
                  ARM, ACTARM, TRT01P or TRT01A.

                IMPORTANT RULES:

                1. Select the most appropriate column based
                   on the meaning of the question.

                2. Only select columns present in the schema.

                3. Return the exact column name.

                4. Extract the requested filter value.

                5. Do not invent columns or values.

                6. Return structured output containing
                   target_column and filter_value only.
                """
            ),

            (
                "human",
                "Translate this question into a dataset filter: {question}"
            )

        ])

    # Parse Question

    def parse_question(self, question):

        if not isinstance(question, str) or not question.strip():
            raise ValueError("Please provide a valid question.")

        if self.use_mock:

            # Predefined demonstration responses
            mock_responses = {

                "give me the subjects who had adverse events of moderate severity": {
                    "target_column": "AESEV",
                    "filter_value": "Moderate"
                },

                "find subjects who experienced headache": {
                    "target_column": "AETERM",
                    "filter_value": "Headache"
                },

                "find subjects with cardiac adverse events": {
                    "target_column": "AESOC",
                    "filter_value": "Cardiac"
                }

            }

            normalised_question = question.strip().lower()

            if normalised_question not in mock_responses:

                raise ValueError(
                    "No mock response available for this question. "
                    "Use an OpenAI API key for general questions."
                )

            result = mock_responses[normalised_question]

        else:

            # Insert schema and question into prompt
            formatted_prompt = self.prompt.invoke({

                "schema": json.dumps(
                    self.schema,
                    indent=4
                ),

                "question": question

            })

            # Generate structured LLM response
            response = self.llm.invoke(formatted_prompt)

            result = response.model_dump()

        # Validate selected column
        target_column = result["target_column"]
        filter_value = result["filter_value"]

        if target_column not in self.schema:

            raise ValueError(
                f"Invalid column selected: {target_column}"
            )

        if not isinstance(filter_value, str) or not filter_value.strip():

            raise ValueError(
                "The filter value cannot be empty."
            )

        return {
            "target_column": target_column,
            "filter_value": filter_value.strip()
        }

    # Pandas Filtering

    def execute_query(self, structured_query):

        target_column = structured_query["target_column"]
        filter_value = structured_query["filter_value"]

        # Case-insensitive partial matching
        mask = (

            self.df[target_column]
            .astype("string")
            .str.contains(
                filter_value,
                case=False,
                na=False,
                regex=False
            )

        )

        # Filter matching records
        filtered_data = self.df.loc[mask]

        # Extract unique subject identifiers
        subject_ids = (

            filtered_data["USUBJID"]
            .dropna()
            .drop_duplicates()
            .tolist()

        )

        return {

            "target_column": target_column,

            "filter_value": filter_value,

            "matching_records": len(filtered_data),

            "unique_subject_count": len(subject_ids),

            "subject_ids": subject_ids

        }


    # Agent Function
    
    def ask(self, question):

        print("\nUser Question:", question)

        # Step 1: Parse question
        structured_query = self.parse_question(question)

        print("\nStructured JSON:")

        print(
            json.dumps(
                structured_query,
                indent=4
            )
        )

        # Step 2: Execute Pandas query
        results = self.execute_query(structured_query)

        print("\nQuery Results:")

        print(
            json.dumps(
                results,
                indent=4,
                default=str
            )
        )

        return results
