// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendChatRequest _$SendChatRequestFromJson(Map<String, dynamic> json) =>
    SendChatRequest(
      chatRoomId: json['chatRoomId'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$SendChatRequestToJson(SendChatRequest instance) =>
    <String, dynamic>{
      'chatRoomId': instance.chatRoomId,
      'content': instance.content,
    };
