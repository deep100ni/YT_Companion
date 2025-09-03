import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../app_route.dart';
import '../models/user.dart';
import '../repo/local_repo.dart';
import '../repo/user_repo.dart';
import '../services/youtube_service.dart';
import 'upload_content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepo userRepo = GetIt.I.get();
  final LocalRepo localRepo = GetIt.I.get();
  final YoutubeService youtubeService = YoutubeService();

  AppUser? user;
  int _currentIndex = 0;

  List<Map<String, dynamic>> videos = [];
  List<Map<String, dynamic>> filteredVideos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    start();
    loadVideos();
  }

  Future<void> loadVideos({String? query}) async {
    setState(() => isLoading = true);
    try {
      final data = await youtubeService.fetchVideos(searchQuery: query);
      setState(() {
        videos = data;
        filteredVideos = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _filterVideos(String query) {
    if (query.isEmpty) {
      setState(() => filteredVideos = videos);
    } else {
      setState(() {
        filteredVideos = videos
            .where((v) =>
        v["title"].toLowerCase().contains(query.toLowerCase()) ||
            v["description"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> start() async {
    final _user = await localRepo.getUser();
    setState(() {
      user = _user;
    });
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
          children: [
            // Profile
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
                    Text(user?.name ?? "User",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("50 Total subscribers",
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search your video...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _filterVideos,
            ),
            const SizedBox(height: 20),

            // Video List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: filteredVideos.length,
                itemBuilder: (context, index) {
                  final video = filteredVideos[index];
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
          setState(() => _currentIndex = index);
          if (index == 1) context.push(AppRoute.profile.path);
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
    required List<Map<String, String>> comments,
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
            const Icon(Icons.play_circle_fill,
                color: Colors.white, size: 30),
          ],
        ),
        title: Text(title,
            style:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
}
