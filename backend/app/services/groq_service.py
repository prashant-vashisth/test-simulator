import json
import logging
from groq import AsyncGroq
from ..core.config import get_settings

logger = logging.getLogger(__name__)

_SYSTEM_TEMPLATE = """You are an encouraging educational writing coach evaluating a {grade_level} student's response.

Analyze the writing and return ONLY a valid JSON object with this exact structure:
{{
  "overall_score": <integer 1-10>,
  "grammar": {{
    "score": <integer 1-10>,
    "issues": [<brief issue strings>],
    "suggestions": [<brief improvement suggestions>]
  }},
  "vocabulary": {{
    "score": <integer 1-10>,
    "strengths": [<words or phrases used well>],
    "improvements": [<suggestions to enrich vocabulary>]
  }},
  "content": {{
    "score": <integer 1-10>,
    "strengths": [<what the student did well>],
    "improvements": [<specific content improvements>]
  }},
  "structure": {{
    "score": <integer 1-10>,
    "feedback": "<one or two sentences about organization>"
  }},
  "overall_feedback": "<2-3 encouraging sentences summarizing the writing>",
  "next_steps": [<2-3 specific, actionable things the student should try next time>]
}}

Be age-appropriate, encouraging, and constructive. Focus on growth over perfection.
Keep lists short (2-3 items max). Calibrate expectations for {grade_level}."""


async def analyze_writing(
    *,
    prompt: str,
    response: str,
    grade_level: str,
) -> dict:
    """Call Groq to analyze a student's writing and return structured feedback."""
    settings = get_settings()
    if not settings.GROQ_API_KEY:
        return _fallback_feedback()

    try:
        client = AsyncGroq(api_key=settings.GROQ_API_KEY)
        completion = await client.chat.completions.create(
            model="llama-3.1-8b-instant",
            messages=[
                {
                    "role": "system",
                    "content": _SYSTEM_TEMPLATE.format(grade_level=grade_level),
                },
                {
                    "role": "user",
                    "content": f"Writing Prompt: {prompt}\n\nStudent Response:\n{response}",
                },
            ],
            response_format={"type": "json_object"},
            max_tokens=800,
            temperature=0.3,
        )
        raw = completion.choices[0].message.content
        return json.loads(raw)
    except Exception as exc:
        logger.warning("Groq analysis failed: %s", exc)
        return _fallback_feedback()


def _fallback_feedback() -> dict:
    """Returned when Groq is unavailable so the session can still complete."""
    return {
        "overall_score": None,
        "grammar": {"score": None, "issues": [], "suggestions": []},
        "vocabulary": {"score": None, "strengths": [], "improvements": []},
        "content": {"score": None, "strengths": [], "improvements": []},
        "structure": {"score": None, "feedback": "Feedback unavailable at this time."},
        "overall_feedback": "Great effort! Feedback will be available once the service is connected.",
        "next_steps": ["Keep writing and practicing!"],
    }
