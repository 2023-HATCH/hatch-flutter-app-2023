// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      uuid: json['uuid'] as String,
      nickname: json['nickname'] as String,
      profileImg: json['profileImg'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'nickname': instance.nickname,
      'profileImg': instance.profileImg ?? '',
      'email': instance.email ?? '',
    };
