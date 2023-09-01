// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowData _$FollowDataFromJson(Map<String, dynamic> json) => FollowData(
<<<<<<< HEAD
      user: UserData.fromJson(json),
      introduce: json['introduce'] as String?,
=======
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      introduce: json['introduce'] as String,
>>>>>>> 223f9355363f22fcb6322bbe905fdd3ddcb2f528
      isFollowing: json['isFollowing'] as bool,
    );

Map<String, dynamic> _$FollowDataToJson(FollowData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'introduce': instance.introduce,
      'isFollowing': instance.isFollowing,
    };
