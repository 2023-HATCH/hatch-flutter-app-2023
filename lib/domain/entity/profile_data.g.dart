// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      isMe: json['isMe'] as bool,
      introduce: json['introduce'] as String?,
      instagramId: json['instagramId'] as String?,
      twitterId: json['twitterId'] as String?,
      followingCount: json['followingCount'] as int,
      followerCount: json['followerCount'] as int,
      isFollowing: json['isFollowing'] as bool,
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'isMe': instance.isMe,
      'introduce': instance.introduce,
      'instagramId': instance.instagramId,
      'twitterId': instance.twitterId,
      'followingCount': instance.followingCount,
      'followerCount': instance.followerCount,
      'isFollowing': instance.isFollowing,
    };
