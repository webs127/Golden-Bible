from pydantic import BaseModel
from typing import List


class Verse(BaseModel):
    reference: str
    text: str


class Devotional(BaseModel):
    title: str
    body: str
    reflection: str
    prayer: str


class DailyDevotional(BaseModel):
    verse: Verse
    devotional: Devotional


class DevotionalCollection(BaseModel):
    devotionals: List[DailyDevotional]