// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$UserFromJson(Map<String, dynamic> json) => AppUser(
  name: json['name'] as String,
  email: json['email'] as String,
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
);

Map<String, dynamic> _$UserToJson(AppUser instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'gender': _$GenderEnumMap[instance.gender],
  'dob': instance.dob?.toIso8601String(),
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};
