import 'package:flutter/material.dart';
import '../services/gemini_service.dart'; // Make sure this path is correct

// It's best practice to use a data model for structured API responses.
// This prevents typos in string keys and makes your code type-safe.
class AnalysisResult {
  final List<String> videoTips;
  final Map<String, List<String>> commentSummary;
  final Map<String, int> audienceSentiment;

  // Convenience getters for easier access in the UI
  List<String> get positiveFeedback => commentSummary['positiveFeedback'] ?? [];
  List<String> get commonQuestions => commentSummary['commonQuestions'] ?? [];

  AnalysisResult({
    required this.videoTips,
    required this.commentSummary,
    required this.audienceSentiment,
  });

  // Factory constructor to parse the JSON map from GeminiService
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      videoTips: List<String>.from(json['videoTips'] ?? []),
      commentSummary: {
        'positiveFeedback': List<String>.from(json['commentSummary']?['positiveFeedback'] ?? []),
        'commonQuestions': List<String>.from(json['commentSummary']?['commonQuestions'] ?? []),
      },
      audienceSentiment: {
        'positive': (json['audienceSentiment']?['positive'] ?? 0).toInt(),
        'neutral': (json['audienceSentiment']?['neutral'] ?? 0).toInt(),
        'negative': (json['audienceSentiment']?['negative'] ?? 0).toInt(),
      },
    );
  }
}


class AnalysisScreen extends StatefulWidget {
  final String title;
  final String description;
  final List<Map<String, String>> comments;

  const AnalysisScreen({
    super.key,
    required this.title,
    required this.description,
    required this.comments,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  AnalysisResult? analysisData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getAnalysis();
  }

  Future<void> _getAnalysis() async {
    // ⚠️ CRITICAL SECURITY WARNING ⚠️
    // Never hardcode your API key in the source code.
    // Use environment variables to keep it secure.
    // final apiKey = String.fromEnvironment('GEMINI_API_KEY');
    // if (apiKey.isEmpty) {
    //   setState(() {
    //     errorMessage = "API Key is not configured. Please set it up via environment variables.";
    //     isLoading = false;
    //   });
    //   return;
    // }
    // final service = GeminiService(apiKey);

    // Using the placeholder key for now, but please replace it.
    final service = GeminiService("AIzaSyB-QyrNxjsfDuKbWsg_VpJKkIhfBDRxPqk"); // ⬅️ Replace with a secure method
    final commentList =
    widget.comments.map((c) => "${c['author']}: ${c['comment']}").toList();

    try {
      final result = await service.analyzeVideo(
          widget.title, widget.description, commentList);

      // We now parse the map into our structured AnalysisResult object
      setState(() {
        analysisData = AnalysisResult.fromJson(result);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to get analysis. Please try again later.\nError: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Analysis"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(errorMessage!, textAlign: TextAlign.center),
          ));
    }

    if (analysisData == null) {
      return const Center(child: Text("No analysis available"));
    }

    // Now we can access data safely, e.g., analysisData!.videoTips
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoTips(analysisData!.videoTips),
          const SizedBox(height: 16),
          _buildCommentSummary(analysisData!),
          const SizedBox(height: 16),
          _buildAudienceSentiment(analysisData!.audienceSentiment),
        ],
      ),
    );
  }

  Widget _buildVideoTips(List<String> tips) {
    // ... (Your existing _buildVideoTips widget code is fine, no changes needed)
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Video Tips",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(tips.length, (index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
                title: Text(tips[index]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSummary(AnalysisResult data) {
    // ... (Your existing _buildCommentSummary widget code can be simplified)
    final List<String> positiveFeedback = data.positiveFeedback;
    final List<String> commonQuestions = data.commonQuestions;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Comment Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Positive Feedback",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green),
            ),
            const SizedBox(height: 8),
            ...positiveFeedback.map((fb) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("\"$fb\""),
            )),
            const SizedBox(height: 16),
            const Text(
              "Common Questions",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
            const SizedBox(height: 8),
            ...commonQuestions.map((q) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("\"$q\""),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAudienceSentiment(Map<String, int> sentiment) {
    // ... (Your existing _buildAudienceSentiment widget code is fine, just needs integers)
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Audience Sentiment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSentimentIndicator(
                "Positive", (sentiment['positive'] ?? 0).toDouble(), Colors.green),
            _buildSentimentIndicator(
                "Neutral", (sentiment['neutral'] ?? 0).toDouble(), Colors.grey),
            _buildSentimentIndicator(
                "Negative", (sentiment['negative'] ?? 0).toDouble(), Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentIndicator(
      String label, double value, Color color) {
    // ... (Your existing _buildSentimentIndicator widget code is fine)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: color.withOpacity(0.2),
              color: color,
              minHeight: 10,
            ),
          ),
          SizedBox(width: 50, child: Text("${value.toInt()}%", textAlign: TextAlign.end)),
        ],
      ),
    );
  }

// REMOVED _buildEngagementInsights widget
}