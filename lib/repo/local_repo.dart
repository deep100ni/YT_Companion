import 'package:shared_preferences/shared_preferences.dart';

class LocalRepo{
  static const _KeyIsLoggedIn = 'isLoggedIn';

  Future<void> onLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_KeyIsLoggedIn, true);
  }

  Future<void> onLoggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_KeyIsLoggedIn, false);
  }

  Future<bool> isLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_KeyIsLoggedIn) ?? false;
  }
}