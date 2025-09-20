import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> analyzeVideo(
      String title, String description, List<String> comments) async {
    final prompt = '''
**Objective:** Review the provided video details (title, description, comments) and give very simple, practical, and easy-to-follow advice for the artist. Keep the suggestions friendly and helpful.

**Video Title:** $title
**Video Description:** $description
**Comments:**
${comments.join("\n")}

---

**Instructions for the AI Model:**
Please return your response only as a single JSON object in the structure below. Avoid complex words or long sentences. Keep all advice easy for beginners to understand and useful for making future videos better.

**Task 1: Easy Video Tips**
- Create a `videoTips` array of short tips (1–2 sentences each).
- Tips should be clear, simple, and directly helpful for the artist (e.g., "Show more of the drawing process step by step" instead of "Increase transparency and improve narrative engagement").

**Task 2: Summarize Key Comments**
- Make a `commentSummary` object with:
  - `positiveFeedback`: short quotes or summaries of nice things people said.
  - `commonQuestions`: simple, common viewer questions or requests.
- Keep sentences short and easy to read.

**Task 3: Audience Sentiment**
- Create an `audienceSentiment` object.
- Estimate the percentage of "positive", "neutral", and "negative" comments (they must add up to 100).
- Keep it simple.

**Final Output Format (JSON only):**
{
  "videoTips": [
    "Easy tip 1...",
    "Easy tip 2..."
  ],
  "commentSummary": {
    "positiveFeedback": [
      "Short positive comment..."
    ],
    "commonQuestions": [
      "Simple common question..."
    ]
  },
  "audienceSentiment": {
    "positive": <integer>,
    "neutral": <integer>,
    "negative": <integer>
  }
}
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '{}';

    try {
      final startIndex = text.indexOf('{');
      final endIndex = text.lastIndexOf('}');

      if (startIndex != -1 && endIndex != -1) {
        final jsonString = text.substring(startIndex, endIndex + 1);
        return Map<String, dynamic>.from(jsonDecode(jsonString));
      } else {
        throw const FormatException("No valid JSON object found in the response.");
      }
    } catch (e) {
      print("⚠️ JSON Parse Error: $e\nRaw Response Text: \n$text");
      return {
        "videoTips": ["Error: Could not generate improvement tips."],
        "commentSummary": {
          "positiveFeedback": ["Could not load feedback."],
          "commonQuestions": ["Could not load questions."]
        },
        "audienceSentiment": {
          "positive": 0,
          "neutral": 0,
          "negative": 0
        }
      };
    }
  }
}
