import json
import os

from dotenv import load_dotenv
from google import genai

from schema import DevotionalCollection


# --------------------------------------------------
# Environment
# --------------------------------------------------

load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise ValueError(
        "GEMINI_API_KEY not found. "
        "Make sure it is set in your .env file."
    )


# --------------------------------------------------
# Gemini client
# --------------------------------------------------

client = genai.Client(api_key=api_key)


# --------------------------------------------------
# Prompt
# --------------------------------------------------

PROMPT = """
Generate exactly 30 Christian daily devotionals.

The output must contain exactly 30 devotional objects.

Each devotional must follow this structure:

{
  "verse": {
    "reference": "Bible verse reference",
    "text": "Bible verse text"
  },
  "devotional": {
    "title": "Devotional title",
    "body": "Devotional body",
    "reflection": "Reflection question",
    "prayer": "Prayer"
  }
}

CONTENT REQUIREMENTS:

1. Generate exactly 30 devotionals.

2. Do not repeat Bible verse references.

3. Use a wide variety of Bible books and passages.

4. Cover different Christian themes, including:
   - Faith
   - Trust
   - Prayer
   - Wisdom
   - Courage
   - Patience
   - Hope
   - Love
   - Forgiveness
   - Gratitude
   - Purpose
   - Discipline
   - Perseverance
   - Humility
   - Obedience
   - God's guidance
   - God's faithfulness
   - Serving others
   - Spiritual growth
   - Overcoming fear

5. Do not make every devotional sound the same.

6. Each devotional body should be approximately 100-150 words.

7. Each reflection should be a thoughtful question
   that encourages personal application.

8. Each prayer should be approximately 40-80 words.

9. The writing should be suitable for a general Christian audience.

10. Avoid shallow motivational statements.

11. Connect the devotional meaningfully to the selected Scripture.

12. Do not add any fields outside the requested schema.

13. Do not include dates.

14. Do not include IDs.

15. Return exactly 30 devotional objects.
"""


# --------------------------------------------------
# Generate
# --------------------------------------------------

def generate_devotionals():

    print("Generating 30 devotionals...")

    response = client.models.generate_content(
        model="gemini-2.0-flash",
        contents=PROMPT,
        config={
            "response_mime_type": "application/json",
            "response_schema": DevotionalCollection,
        },
    )

    if not response.text:
        raise ValueError("Gemini returned an empty response.")

    result = DevotionalCollection.model_validate_json(
        response.text
    )

    return result


# --------------------------------------------------
# Validate
# --------------------------------------------------

def validate_devotionals(result):

    devotionals = result.devotionals

    # Check count
    if len(devotionals) != 30:
        raise ValueError(
            f"Expected 30 devotionals, "
            f"but received {len(devotionals)}."
        )

    # Check duplicate Bible references
    references = [
        devotional.verse.reference.strip().lower()
        for devotional in devotionals
    ]

    if len(references) != len(set(references)):
        duplicates = [
            reference
            for reference in set(references)
            if references.count(reference) > 1
        ]

        raise ValueError(
            f"Duplicate Bible verses detected: {duplicates}"
        )

    # Check empty fields
    for index, devotional in enumerate(devotionals, start=1):

        if not devotional.verse.reference.strip():
            raise ValueError(
                f"Devotional {index}: missing verse reference."
            )

        if not devotional.verse.text.strip():
            raise ValueError(
                f"Devotional {index}: missing verse text."
            )

        if not devotional.devotional.title.strip():
            raise ValueError(
                f"Devotional {index}: missing title."
            )

        if not devotional.devotional.body.strip():
            raise ValueError(
                f"Devotional {index}: missing body."
            )

        if not devotional.devotional.reflection.strip():
            raise ValueError(
                f"Devotional {index}: missing reflection."
            )

        if not devotional.devotional.prayer.strip():
            raise ValueError(
                f"Devotional {index}: missing prayer."
            )

    print("Validation passed.")
    print(f"Devotionals: {len(devotionals)}")
    print("Duplicate verses: 0")


# --------------------------------------------------
# Save
# --------------------------------------------------

def save_json(result):

    output_file = "devotionals.json"

    with open(
        output_file,
        "w",
        encoding="utf-8"
    ) as file:

        json.dump(
            result.model_dump(),
            file,
            indent=2,
            ensure_ascii=False
        )

    print(f"Saved to {output_file}")


# --------------------------------------------------
# Main
# --------------------------------------------------

def main():

    try:

        result = generate_devotionals()

        validate_devotionals(result)

        save_json(result)

        print("\nDone!")

    except Exception as error:

        print("\nGeneration failed.")
        print(f"Error: {error}")


if __name__ == "__main__":
    main()