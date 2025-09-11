// youtube_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeService {
  final String apiKey =
      "AIzaSyAICh5kwtWeAj-q-iRCo-fos10_bNaUj_k"; // Replace with your actual API key

  /// Fetch videos with metadata + stats
  Future<List<Map<String, dynamic>>> fetchVideos({
    required String channelId,
    String? searchQuery,
  }) async {
    List<Map<String, dynamic>> videos = [];
    String? nextPageToken;

    do {
      final url =
          "https://www.googleapis.com/youtube/v3/search"
          "?part=snippet"
          "&channelId=$channelId"
          "&maxResults=50"
          "&order=date"
          "&type=video"
          "&q=${searchQuery ?? ""}"
          "&pageToken=${nextPageToken ?? ""}"
          "&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Error fetching videos: ${response.body}");
      }

      final data = json.decode(response.body);
      final List items = data["items"];
      nextPageToken = data["nextPageToken"];

      // Collect video IDs
      final List<String> videoIds =
      items.map((item) => item["id"]["videoId"] as String).toList();

      // Fetch all stats in one go
      final statsMap = await fetchVideoStatsBatch(videoIds);

      // Build video list
      for (var item in items) {
        final snippet = item["snippet"];
        final videoId = item["id"]["videoId"];

        videos.add({
          "videoId": videoId,
          "thumbnail": snippet["thumbnails"]["high"]["url"],
          "title": snippet["title"],
          "time": snippet["publishedAt"],
          "description": snippet["description"]?.isNotEmpty == true
              ? snippet["description"]
              : "No description available",
          "views": statsMap[videoId]?["viewCount"] ?? "0",
          // Lazy load comments only when needed
          "commentsLoader": () => fetchAllComments(videoId),
        });
      }
    } while (nextPageToken != null);

    return videos;
  }

  /// Batch fetch video stats (up to 50 IDs per call)
  Future<Map<String, dynamic>> fetchVideoStatsBatch(
      List<String> videoIds) async {
    if (videoIds.isEmpty) return {};

    final url =
        "https://www.googleapis.com/youtube/v3/videos"
        "?part=statistics"
        "&id=${videoIds.join(',')}"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return {};

    final data = json.decode(response.body);
    final Map<String, dynamic> statsMap = {};

    for (var item in data["items"]) {
      statsMap[item["id"]] = item["statistics"];
    }

    return statsMap;
  }

  /// Fetch all comments for a video (optional on-demand)
  Future<List<Map<String, String>>> fetchAllComments(String videoId) async {
    List<Map<String, String>> comments = [];
    String? nextPageToken;

    do {
      final url =
          "https://www.googleapis.com/youtube/v3/commentThreads"
          "?part=snippet"
          "&videoId=$videoId"
          "&maxResults=50"
          "&pageToken=${nextPageToken ?? ""}"
          "&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var item in data["items"]) {
          final snippet = item["snippet"]["topLevelComment"]["snippet"];
          comments.add({
            "author": snippet["authorDisplayName"],
            "comment": snippet["textDisplay"],
          });
        }
        nextPageToken = data["nextPageToken"];
      } else {
        break;
      }
    } while (nextPageToken != null);

    return comments;
  }

  /// Get channel ID from @handle
  Future<String?> fetchChannelIdFromHandle(String handle) async {
    final url =
        "https://www.googleapis.com/youtube/v3/channels"
        "?part=id&forHandle=$handle&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["items"].isNotEmpty) {
        return data["items"][0]["id"];
      }
    }
    return null;
  }

  /// Fetch channel details (title, description, thumbnail, subscriber count)
  Future<Map<String, dynamic>?> fetchChannelDetails(String channelId) async {
    final url = "https://www.googleapis.com/youtube/v3/channels"
        "?part=snippet,statistics" // Request snippet and statistics
        "&id=$channelId"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    if (data["items"].isEmpty) return null;

    final item = data["items"][0];
    final snippet = item["snippet"];
    final statistics = item["statistics"];

    return {
      "title": snippet["title"],
      "description": snippet["description"],
      "thumbnail": snippet["thumbnails"]["high"]["url"],
      "subscriberCount": statistics["subscriberCount"],
    };
  }
}