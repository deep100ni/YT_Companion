import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> analyzeVideo(
      String title, String description, List<String> comments) async {
    // --- PROMPT UPDATED HERE ---
    final prompt = '''
Analyze the following video's title, description, and comments.

**Title:** $title
**Description:** $description
**Comments:** ${comments.join("\n")}

Your main goal is to provide actionable advice to help the creator improve their content and grow their audience.

Return ONLY a raw JSON string with the following structure:
{
  "videoTips": [
    "Tip 1: A specific, actionable tip on how to make the first 15 seconds more engaging to improve audience retention.",
    "Tip 2: A constructive suggestion regarding the video's pacing, editing, or clarity to keep viewers engaged.",
    "Tip 3: A recommendation for adding specific visual elements (like graphics, text overlays, or B-roll) to better explain complex topics.",
    "Tip 4: An idea for a follow-up video on a related or more advanced topic that the audience is asking for or would likely enjoy."
  ],
  "commentSummary": {
    "positiveFeedback": [
      "A direct quote of positive feedback from the comments.",
      "Another summarized piece of positive feedback."
    ],
    "commonQuestions": [
      "A frequently asked question from the comments.",
      "Another common question or a request for a future video."
    ]
  },
  "audienceSentiment": {
    "positive": 78,
    "neutral": 18,
    "negative": 4
  },
  "engagementInsights": {
    "likeRatio": 96,
    "commentRate": 12,
    "shareRate": 8
  }
}
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '{}';

    try {
      // Clean the response to ensure it's valid JSON before parsing
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
      // Fallback structure to prevent null errors in the UI
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
        },
        "engagementInsights": {
          "likeRatio": 0,
          "commentRate": 0,
          "shareRate": 0
        }
      };
    }
  }
}