// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_detail_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDetailListItem _$ChatDetailListItemFromJson(Map<String, dynamic> json) =>
    ChatDetailListItem(
      chatMessageId: json['chatMessageId'] as String,
      createdAt: json['createdAt'] as String,
      sender: UserListItem.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
    );

Map<String, dynamic> _$ChatDetailListItemToJson(ChatDetailListItem instance) =>
    <String, dynamic>{
      'chatMessageId': instance.chatMessageId,
      'createdAt': instance.createdAt,
      'sender': instance.sender,
      'content': instance.content,
    };
