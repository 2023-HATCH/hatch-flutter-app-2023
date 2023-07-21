// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserListItem _$ChatUserListItemFromJson(Map<String, dynamic> json) =>
    ChatUserListItem(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      profileImg: json['profileImg'] as String?,
    );

Map<String, dynamic> _$ChatUserListItemToJson(ChatUserListItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImg': instance.profileImg,
    };
