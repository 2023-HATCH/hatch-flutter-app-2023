// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkMessageResponse _$TalkMessageResponseFromJson(Map<String, dynamic> json) =>
    TalkMessageResponse(
      content: json['content'] as String,
      sender: UserListItem.fromJson(json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TalkMessageResponseToJson(
        TalkMessageResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'sender': instance.sender,
    };
