// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowListResponse _$FollowListResponseFromJson(Map<String, dynamic> json) =>
    FollowListResponse(
      followerList: (json['followerList'] as List<dynamic>)
          .map((e) => FollowData.fromJson(e as Map<String, dynamic>))
          .toList(),
      followingList: (json['followingList'] as List<dynamic>)
          .map((e) => FollowData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FollowListResponseToJson(FollowListResponse instance) =>
    <String, dynamic>{
      'followerList': instance.followerList,
      'followingList': instance.followingList,
    };
