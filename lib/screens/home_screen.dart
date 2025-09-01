import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/repo/local_repo.dart';
import 'package:trip_planner/repo/user_repo.dart';
import '../app_route.dart';
import '../models/user.dart';
import 'upload_content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepo userRepo = GetIt.I.get();
  final LocalRepo localRepo = GetIt.I.get();

  AppUser? user;
  int _currentIndex = 0;

  final videos = [
    {
      "thumbnail": "https://img.youtube.com/vi/Ke90Tje7VS0/0.jpg",
      "title": "Complete React Tutorial for Beginners 2024",
      "views": "125K views",
      "time": "2 days ago",
      "description": "A complete React.js crash course for beginners in 2024.",
      "comments": "User1: Awesome tutorial!\nUser2: Please explain hooks more."
    },
    {
      "thumbnail": "https://img.youtube.com/vi/l9AzO1FMgM8/0.jpg",
      "title": "Building AI Apps with OpenAI GPT-4",
      "views": "89K views",
      "time": "1 week ago",
      "description": "Learn how to build AI-powered apps using OpenAI GPT-4.",
      "comments": "User3: Super helpful!\nUser4: Can you add chatbot example?"
    },
    {
      "thumbnail": "https://img.youtube.com/vi/M7lc1UVf-VE/0.jpg",
      "title": "YouTube Analytics Deep Dive 2024",
      "views": "67K views",
      "time": "3 days ago",
      "description": "In-depth guide to YouTube analytics features for 2024.",
      "comments": "User5: Very detailed!\nUser6: How about Shorts analytics?"
    },
    {
      "thumbnail": "https://img.youtube.com/vi/ktjafK4SgWM/0.jpg",
      "title": "Mobile App Design Trends 2024",
      "views": "45K views",
      "time": "5 days ago",
      "description": "Latest UI/UX design trends for mobile apps in 2024.",
      "comments": "User7: Clean design tips!\nUser8: Can you cover dark mode?"
    },
    {
      "thumbnail": "https://img.youtube.com/vi/2Ji-clqUYnA/0.jpg",
      "title": "JavaScript ES2024 New Features",
      "views": "92K views",
      "time": "1 week ago",
      "description": "Explore the latest ES2024 JavaScript features.",
      "comments": "User9: Love the examples!\nUser10: Please add async updates."
    },
  ];

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('AI Marketplace Assistant'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    user?.photoUrl ?? "https://example.com/profile.png",
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? "User",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "50 Total subscribers",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Your Videos Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Your Videos",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Chip(label: Text("${videos.length} videos")),
              ],
            ),

            const SizedBox(height: 10),

            // Video List
            Expanded(
              child: ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return _videoCard(
                    thumbnailUrl: video["thumbnail"]!,
                    title: video["title"]!,
                    views: video["views"]!,
                    timeAgo: video["time"]!,
                    description: video["description"]!,
                    comments: video["comments"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            context.push(AppRoute.profile.path);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _videoCard({
    required String thumbnailUrl,
    required String title,
    required String views,
    required String timeAgo,
    required String description,
    required String comments,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                thumbnailUrl,
                width: 80,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
          ],
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Row(
          children: [
            const Icon(Icons.visibility, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(views),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(timeAgo),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadContentScreen(
                title: title,
                description: description,
                thumbnailUrl: thumbnailUrl,
                comments: comments,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> start() async {
    final _user = await localRepo.getUser();
    setState(() {
      user = _user;
    });
  }
}
