// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_detail_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDetailListItem _$ChatDetailListItemFromJson(Map<String, dynamic> json) =>
    ChatDetailListItem(
      content: json['content'] as String,
      sender: UserListItem.fromJson(json['sender'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$ChatDetailListItemToJson(ChatDetailListItem instance) =>
    <String, dynamic>{
      'content': instance.content,
      'sender': instance.sender,
      'createdAt': instance.createdAt,
    };
