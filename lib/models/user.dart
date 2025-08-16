import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum Gender {
  male, female, other
}

@JsonSerializable()
class AppUser{
  String name;
  String email;
  Gender? gender;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? dob;
  String? photoUrl;

  AppUser({
    required this.name,
    required this.email,
    this.gender,
    this.dob,
    this.photoUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  static DateTime? _fromJson(Timestamp? ts) => ts?.toDate();
  static Timestamp? _toJson(DateTime? dt) => dt == null ? null : Timestamp.fromDate(dt);
}