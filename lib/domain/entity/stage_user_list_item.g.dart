// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_user_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageUserListItem _$StageUserListItemFromJson(Map<String, dynamic> json) =>
    StageUserListItem(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      profileImg: json['profileImg'] as String?,
    );

Map<String, dynamic> _$StageUserListItemToJson(StageUserListItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImg': instance.profileImg,
    };
