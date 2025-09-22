import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OfflineWidget extends StatelessWidget {
  final VoidCallback retry;

  const OfflineWidget({
    super.key,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/illustration_offline.svg",
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "You're Offline",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),

                // Subtitle
                Text(
                  "You're currently offline. Reconnect to\ncontinue using the app.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                // Retry Button
                ElevatedButton(
                  onPressed: retry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
