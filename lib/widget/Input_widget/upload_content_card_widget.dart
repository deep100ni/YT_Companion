import 'package:flutter/material.dart';

class UploadContentCard extends StatelessWidget {
  final VoidCallback onTap;

  const UploadContentCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160, // you can adjust
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.upload_outlined,
                size: 32,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Upload Content",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Add your video and\nthumbnail",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
