import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> analyzeVideo(
      String title, String description, List<String> comments) async {
    final prompt = '''
**Objective:** Analyze the provided video content (title, description, comments) and generate a structured JSON output containing actionable advice, a summary of feedback, and a sentiment analysis of the comments.

**Video Title:** $title
**Video Description:** $description
**Comments:**
${comments.join("\n")}

---

**Instructions for the AI Model:**
Carefully review all the provided information. Fulfill each of the following tasks and structure your entire response as a single, raw JSON object. Do not include any text or formatting outside of the JSON structure.

**Task 1: Generate Actionable Video Tips**
- Create a `videoTips` array of strings.
- Each string should be a unique, specific, and actionable tip for the content creator.
- Base these tips on the video's title, description, and the feedback within the comments.

**Task 2: Summarize Key Comments**
- Create a `commentSummary` object.
- Inside this object, create two arrays of strings: `positiveFeedback` and `commonQuestions`.
- Populate `positiveFeedback` with direct quotes or summaries of encouraging comments.
- Populate `commonQuestions` with frequently asked questions or suggestions for future videos found in the comments.

**Task 3: Analyze Audience Sentiment**
- Create an `audienceSentiment` object.
- **Based ONLY on the provided comments**, classify the sentiment of the audience.
- Calculate the percentage for "positive", "neutral", and "negative" sentiments.
- The sum of these three percentages must equal 100.

**Final Output Structure:**
Return ONLY a raw JSON string matching this exact format:
{
  "videoTips": [
    "Actionable tip based on the provided content...",
    "Another constructive suggestion..."
  ],
  "commentSummary": {
    "positiveFeedback": [
      "Summary of positive feedback from comments...",
      "A direct quote of positive feedback..."
    ],
    "commonQuestions": [
      "A common question asked by viewers...",
      "A request for a follow-up video..."
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
