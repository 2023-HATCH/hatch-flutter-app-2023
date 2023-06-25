// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_signup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInSignUpResponse _$SignInSignUpResponseFromJson(
        Map<String, dynamic> json) =>
    SignInSignUpResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignInSignUpResponseToJson(
        SignInSignUpResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
