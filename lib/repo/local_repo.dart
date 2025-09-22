import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner/models/user.dart';

class LocalRepo {
  static const _KeyUser = 'isLoggedIn';

  Future<void> onLoggedIn(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final json = user.toJson();

    // Convert dob to string before saving
    if (json['dob'] is Timestamp) {
      json['dob'] = (json['dob'] as Timestamp).toDate().toIso8601String();
    }
    prefs.setString(_KeyUser, jsonEncode(json));
  }

  Future<void> onLoggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_KeyUser);
  }

  Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_KeyUser);
    if (userJson == null) return null;

    final json = jsonDecode(userJson);

    if (json['dob'] != null && json['dob'] is String) {
      json['dob'] = Timestamp.fromDate(DateTime.parse(json['dob']));
    }

    return AppUser.fromJson(json);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_KeyUser);
  }
}
