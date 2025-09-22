import 'package:flutter/material.dart';
import 'package:trip_planner/screens/upload_content_screen.dart';

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final String views;
  final String timeAgo;

  const VideoCard({
    Key? key,
    required this.thumbnailUrl,
    required this.title,
    required this.views,
    required this.timeAgo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadContentScreen(
                title: title,
                description: "This is a sample video description for $title.",
                thumbnailUrl: thumbnailUrl, comments: [],
              ),
            ),
          );
        },
        child: Row(
          children: [
            // Thumbnail with play icon
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    thumbnailUrl,
                    width: 110,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 32),
              ],
            ),
            const SizedBox(width: 12),

            // Title + Views + Time
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Views & Time ago row
                    Row(
                      children: [
                        const Icon(Icons.visibility,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          views,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
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
