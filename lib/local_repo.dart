import 'package:shared_preferences/shared_preferences.dart';

class LocalRepo{
  Future<void> onLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggrdIn', true);
  }
  Future<bool> isLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}