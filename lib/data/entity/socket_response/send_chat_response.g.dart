// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chat_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendChatResponse _$SendChatResponseFromJson(Map<String, dynamic> json) =>
    SendChatResponse(
      content: json['content'] as String,
      sender: UserListItem.fromJson(json['sender'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$SendChatResponseToJson(SendChatResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'sender': instance.sender,
      'createdAt': instance.createdAt,
    };
