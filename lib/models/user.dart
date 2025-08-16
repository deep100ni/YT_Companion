import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum Gender {
  male, female, other
}

@JsonSerializable()
class AppUser{
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;
  String name;
  String email;
  Gender? gender;

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? dob;
  String? photoUrl;

  AppUser({
    this.id = '',
    required this.name,
    required this.email,
    this.gender,
    this.dob,
    this.photoUrl,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    Gender? gender,
    DateTime? dob,
    String? photoUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json, String id) {
    final user = _$AppUserFromJson(json);
    return user.copyWith(id: id);
  }
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  static DateTime? _fromJson(Timestamp? ts) => ts?.toDate();
  static Timestamp? _toJson(DateTime? dt) => dt == null ? null : Timestamp.fromDate(dt);
}