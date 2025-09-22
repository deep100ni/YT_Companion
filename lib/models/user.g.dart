// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
  id: json['id'] as String? ?? '',
  name: json['name'] as String,
  email: json['email'] as String,
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  dob: AppUser._fromJson(json['dob'] as Timestamp?),
  photoUrl: json['photoUrl'] as String?,
  channelId: json['channelId'] as String?,
);

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'gender': _$GenderEnumMap[instance.gender],
  'dob': AppUser._toJson(instance.dob),
  'photoUrl': instance.photoUrl,
  'channelId': instance.channelId,
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};
