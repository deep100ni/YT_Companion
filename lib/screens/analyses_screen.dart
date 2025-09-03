import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

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
  Map<String, dynamic>? analysisData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAnalysis();
  }

  Future<void> _getAnalysis() async {
    final service = GeminiService("AIzaSyDypeISGo1ikzDtD3UpvvXcSLPO9HtVwY8"); // 🔑 Replace with your Gemini API key
    final commentList =
    widget.comments.map((c) => "${c['author']}: ${c['comment']}").toList();
    final result =
    await service.analyzeVideo(widget.title, widget.description, commentList);

    setState(() {
      analysisData = result;
      isLoading = false;
    });
  }

  Widget _sentimentBar(String label, int value, Color color) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 8,
          ),
        ),
        const SizedBox(width: 8),
        Text("$value%"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tips = List<String>.from(analysisData?["videoTips"] ?? []);
    final positiveFeedback = List<String>.from(
        analysisData?["commentSummary"]?["positiveFeedback"] ?? []);
    final commonQuestions = List<String>.from(
        analysisData?["commentSummary"]?["commonQuestions"] ?? []);
    final sentiment = analysisData?["audienceSentiment"] ??
        {"positive": 0, "neutral": 0, "negative": 0};
    final engagement = analysisData?["engagementInsights"] ??
        {"likeRatio": 0, "commentRate": 0, "shareRate": 0};

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Analysis"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Video Tips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("💡 Video Tips",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (tips.isEmpty)
                      const Text("No tips available")
                    else
                      ...tips.asMap().entries.map((e) =>
                          Text("${e.key + 1}. ${e.value}")),
                  ],
                ),
              ),
            ),

            // 🔹 Comment Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("💬 Comment Summary",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Positive Feedback",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    ...positiveFeedback.map((f) => Text("• $f")),
                    const SizedBox(height: 8),
                    const Text("Common Questions",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    ...commonQuestions.map((q) => Text("• $q")),
                  ],
                ),
              ),
            ),

            // 🔹 Audience Sentiment
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("📊 Audience Sentiment",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _sentimentBar(
                        "Positive", sentiment["positive"], Colors.green),
                    const SizedBox(height: 6),
                    _sentimentBar(
                        "Neutral", sentiment["neutral"], Colors.grey),
                    const SizedBox(height: 6),
                    _sentimentBar(
                        "Negative", sentiment["negative"], Colors.red),
                  ],
                ),
              ),
            ),

            // 🔹 Engagement Insights
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("📈 Engagement Insights",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Like Ratio: ${engagement['likeRatio']}%"),
                    Text("Comment Rate: ${engagement['commentRate']}%"),
                    Text("Share Rate: ${engagement['shareRate']}%"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
