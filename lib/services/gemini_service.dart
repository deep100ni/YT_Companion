import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> analyzeVideo(
      String title, String description, List<String> comments) async {
    final prompt = '''
Analyze this video and provide structured insights.

Title: $title
Description: $description
Comments: ${comments.join("\n")}

Return JSON like:
{
  "videoTips": ["...", "...", "...", "..."],
  "commentSummary": {
    "positiveFeedback": ["...", "..."],
    "commonQuestions": ["...", "..."]
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
      return Map<String, dynamic>.from(jsonDecode(text));
    } catch (e) {
      print("⚠️ JSON Parse Error: $e\n$text");
      // fallback structure to prevent null errors
      return {
        "videoTips": [],
        "commentSummary": {
          "positiveFeedback": [],
          "commonQuestions": []
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
