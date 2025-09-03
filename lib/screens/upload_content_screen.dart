import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trip_planner/screens/analyses_screen.dart';

class UploadContentScreen extends StatelessWidget {
  final String title;
  final String description;
  final String thumbnailUrl;
  final List<Map<String, String>> comments;

  const UploadContentScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 5,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              thumbnailUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(description),
          ),
          const Divider(),

          // Comments
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Comments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(
            child: comments.isEmpty
                ? const Center(child: Text("No comments available"))
                : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final c = comments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: const Icon(Iconsax.user),
                    title: Text(
                      c["author"] ?? "Unknown User",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(c["comment"] ?? ""),
                  ),
                );
              },
            ),
          ),

          // 🚀 Analyze Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.analytics),
              label: const Text("Analyze with AI"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnalysisScreen(
                      title: title,
                      description: description,
                      comments: comments,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
