# Question 6 Test Script
# Clinical Data Assistant

import os
import pandas as pd

from pathlib import Path
from src.clinical_agent import ClinicalTrialDataAgent

# Import data
PROJECT_ROOT = Path(__file__).resolve().parents[1]

DATA_PATH = PROJECT_ROOT / "data" / "adae.csv"

if not DATA_PATH.exists():

    raise FileNotFoundError(
        f"Dataset not found: {DATA_PATH}\n"
        "Please place adae.csv inside the data folder."
    )

ae = pd.read_csv(DATA_PATH)

print("Dataset loaded successfully!")
print("Dataset shape:", ae.shape)

# Mock mode or LLM?
# Set USE_MOCK=true to force MOCK mode.
# Otherwise, use OpenAI when an API key is available.

force_mock = os.getenv("USE_MOCK", "").lower() == "true"

use_mock = force_mock or not bool(
    os.getenv("OPENAI_API_KEY")
)

print("\nMOCK MODE:", use_mock)

# Initialise Agent

agent = ClinicalTrialDataAgent(
    dataframe=ae,
    use_mock=use_mock
)

# Test Questions
test_questions = [

    "Give me the subjects who had adverse events of Moderate severity",

    "Find subjects who experienced Headache",

    "Find subjects with Cardiac adverse events"

]

# Execute test questions
for i, question in enumerate(test_questions, start=1):

    print("\n" + "=" * 65)

    print(f"TEST CASE {i}")

    print("=" * 65)

    try:

        results = agent.ask(question)

        print("\nFINAL SUMMARY")

        print("-" * 40)

        print(
            "Target Column:",
            results["target_column"]
        )

        print(
            "Filter Value:",
            results["filter_value"]
        )

        print(
            "Matching Records:",
            results["matching_records"]
        )

        print(
            "Unique Subjects:",
            results["unique_subject_count"]
        )

        print(
            "Subject IDs:",
            results["subject_ids"]
        )

    except Exception as e:

        print("\nERROR:", str(e))

