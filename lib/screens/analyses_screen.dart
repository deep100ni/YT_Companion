import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
    // 🔑 Replace with your Gemini API key
    final service = GeminiService("AIzaSyDypeISGo1ikzDtD3UpvvXcSLPO9HtVwY8");
    final commentList =
    widget.comments.map((c) => "${c['author']}: ${c['comment']}").toList();

    final result = await service.analyzeVideo(
        widget.title, widget.description, commentList);

    setState(() {
      analysisData = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Analysis"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : analysisData == null
          ? const Center(child: Text("No analysis available"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoTips(analysisData!['videoTips']),
            const SizedBox(height: 16),
            _buildCommentSummary(analysisData!['commentSummary']),
            const SizedBox(height: 16),
            _buildAudienceSentiment(
                analysisData!['audienceSentiment']),
            const SizedBox(height: 16),
            _buildEngagementInsights(
                analysisData!['engagementInsights']),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoTips(List<dynamic> tips) {
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

  Widget _buildCommentSummary(Map<String, dynamic> summary) {
    final List<dynamic> positiveFeedback = summary['positiveFeedback'];
    final List<dynamic> commonQuestions = summary['commonQuestions'];

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

  Widget _buildAudienceSentiment(Map<String, dynamic> sentiment) {
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
                "Positive", sentiment['positive'].toDouble(), Colors.green),
            _buildSentimentIndicator(
                "Neutral", sentiment['neutral'].toDouble(), Colors.grey),
            _buildSentimentIndicator(
                "Negative", sentiment['negative'].toDouble(), Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentIndicator(
      String label, double value, Color color) {
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

  Widget _buildEngagementInsights(Map<String, dynamic> insights) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Engagement Insights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInsight(
                    "${insights['likeRatio']}%", "Like Ratio"),
                _buildInsight(
                    "${insights['commentRate']}%", "Comment Rate"),
                _buildInsight(
                    "${insights['shareRate']}%", "Share Rate"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsight(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}