// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserListItem _$ChatUserListItemFromJson(Map<String, dynamic> json) =>
    ChatUserListItem(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String?,
      profileImg: json['profileImg'] as String?,
      introduce: json['introduce'] as String?,
    );

Map<String, dynamic> _$ChatUserListItemToJson(ChatUserListItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'email': instance.email,
      'profileImg': instance.profileImg,
      'introduce': instance.introduce,
    };
