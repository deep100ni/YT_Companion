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
  DateTime? dob;

  AppUser({
    required this.name,
    required this.email,
     this.gender,
    this.dob,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}