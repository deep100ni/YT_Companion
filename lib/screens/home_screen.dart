// home_screen.dart
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

  // State variables for channel details
  String? channelTitle;
  String? channelThumbnailUrl;
  String? subscriberCount;
  String? channelDescription;

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    final _user = await localRepo.getUser();
    setState(() => user = _user);

    if (user?.channelId != null) {
      // Fetch channel details
      final details =
      await youtubeService.fetchChannelDetails(user!.channelId!);
      setState(() {
        channelTitle = details?["title"];
        channelThumbnailUrl = details?["thumbnail"];
        subscriberCount = details?["subscriberCount"];
        channelDescription = details?["description"];
      });

      // Fetch videos
      await loadVideos();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> loadVideos({String? query}) async {
    setState(() => isLoading = true);
    try {
      if (user?.channelId == null) {
        setState(() => isLoading = false);
        return;
      }
      final data = await youtubeService.fetchVideos(
        channelId: user!.channelId!,
        searchQuery: query,
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Marketplace Assistant'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Channel Info
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    channelThumbnailUrl ?? "https://via.placeholder.com/150",
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channelTitle ?? "Channel Name",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscriberCount != null
                          ? "$subscriberCount subscribers"
                          : "No channel linked",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Channel Description Card
            if (channelDescription != null) ...[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  height: 150, // fixed height with scroll
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            channelDescription!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

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

            // Video List / Empty State
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (user?.channelId == null
                  ? const Center(
                child: Text(
                    "No YouTube channel linked. Go to Profile to add one."),
              )
                  : ListView.builder(
                itemCount: filteredVideos.length,
                itemBuilder: (context, index) {
                  final video = filteredVideos[index];
                  return _videoCard(video);
                },
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() => _currentIndex = index);
          if (index == 1) {
            await context.push(AppRoute.profile.path);
            await start(); // refresh when back
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _videoCard(Map<String, dynamic> video) {
    final thumbnailUrl = video["thumbnail"] ?? "";
    final title = video["title"] ?? "";
    final views = video["views"] ?? "0";
    final timeAgo = video["time"] ?? "";
    final description = video["description"] ?? "";
    final commentsLoader = video["commentsLoader"];

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
        onTap: () async {
          // fetch comments only when opening video
          List<Map<String, String>> comments = [];
          if (commentsLoader != null) {
            comments = await commentsLoader();
          }

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