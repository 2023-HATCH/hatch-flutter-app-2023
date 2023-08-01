// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KaKaoLoginResponse _$KaKaoLoginResponseFromJson(Map<String, dynamic> json) =>
    KaKaoLoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KaKaoLoginResponseToJson(KaKaoLoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
