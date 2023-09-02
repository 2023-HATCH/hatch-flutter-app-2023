// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowData _$FollowDataFromJson(Map<String, dynamic> json) => FollowData(
      user: UserData.fromJson(json),
      introduce: json['introduce'] as String?,
      isFollowing: json['isFollowing'] as bool,
    );

Map<String, dynamic> _$FollowDataToJson(FollowData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'introduce': instance.introduce,
      'isFollowing': instance.isFollowing,
    };
