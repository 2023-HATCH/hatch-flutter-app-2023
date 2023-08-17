// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileData _$UserProfileDataFromJson(Map<String, dynamic> json) =>
    UserProfileData(
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      isMe: json['isMe'] as bool,
      introduce: json['introduce'] as String,
      instagramId: json['instagramId'] as String,
      twitterId: json['twitterId'] as String,
      followingCount: json['followingCount'] as int,
      followerCount: json['followerCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    );

Map<String, dynamic> _$UserProfileDataToJson(UserProfileData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'isMe': instance.isMe,
      'introduce': instance.introduce,
      'instagramId': instance.instagramId,
      'twitterId': instance.twitterId,
      'followingCount': instance.followingCount,
      'followerCount': instance.followerCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
    };
