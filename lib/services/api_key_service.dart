import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyService {
  static const _apiKey = "gemini_api_key";

  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKey, apiKey);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKey);
  }
}