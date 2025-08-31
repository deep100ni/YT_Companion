import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UploadContentScreen extends StatefulWidget {
  const UploadContentScreen({Key? key}) : super(key: key);

  @override
  State<UploadContentScreen> createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Content"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Title
            const Text("Video Title",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter your video title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: descController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Describe your video content...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Upload Thumbnail
            const Text("Upload Thumbnail",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                // TODO: implement image picker
              },
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.image, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text("Tap to upload thumbnail"),
                    const SizedBox(height: 4),
                    Text("PNG, JPG up to 5MB",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Comments
            const Text("Comments",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: commentsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Paste your video comments here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Copy comments from your YouTube video to analyze audience feedback",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            // Analyze Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Iconsax.arrow_down, color: Colors.white),
                label: const Text(
                  "Analyze with AI",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  // TODO: handle AI analysis
                },
              ),
            ),
            const SizedBox(height: 20),

            // Tips Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Tips for better analysis:",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  SizedBox(height: 8),
                  Text("• Include both positive and negative comments"),
                  Text("• Add comments from different time periods"),
                  Text("• Include questions from viewers"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
