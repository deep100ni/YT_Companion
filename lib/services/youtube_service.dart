import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeService {
  final String apiKey = "AIzaSyAICh5kwtWeAj-q-iRCo-fos10_bNaUj_k";
  final String channelId = "UCKwZlZqWAA3G1IV-mdXeMaw";

  /// Fetch ALL videos (with pagination), optional search
  Future<List<Map<String, dynamic>>> fetchVideos({String? searchQuery}) async {
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

      for (var item in items) {
        final snippet = item["snippet"];
        final videoId = item["id"]["videoId"];

        final stats = await fetchVideoStats(videoId);
        final views = stats["viewCount"] ?? "0";
        final comments = await fetchAllComments(videoId);

        videos.add({
          "videoId": videoId,
          "thumbnail": snippet["thumbnails"]["high"]["url"],
          "title": snippet["title"],
          "time": snippet["publishedAt"],
          "description": snippet["description"]?.isNotEmpty == true
              ? snippet["description"]
              : "No description available",
          "views": views,
          "comments": comments,
        });
      }
    } while (nextPageToken != null);

    return videos;
  }

  /// Fetch video statistics
  Future<Map<String, dynamic>> fetchVideoStats(String videoId) async {
    final url =
        "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=$videoId&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["items"].isNotEmpty) {
        return data["items"][0]["statistics"];
      }
    }
    return {};
  }

  /// Fetch all comments
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
}
