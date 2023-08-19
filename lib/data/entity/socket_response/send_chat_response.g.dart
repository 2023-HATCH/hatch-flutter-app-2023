// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendChatResponse _$SendChatResponseFromJson(Map<String, dynamic> json) =>
    SendChatResponse(
      createdAt: json['createdAt'] as String,
      sender: UserListItem.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
    );

Map<String, dynamic> _$SendChatResponseToJson(SendChatResponse instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'sender': instance.sender,
      'content': instance.content,
    };
