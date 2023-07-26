// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_talk_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageTalkListItem _$StageTalkListItemFromJson(Map<String, dynamic> json) =>
    StageTalkListItem(
      content: json['content'] as String,
      sender: ChatUserListItem.fromJson(json['sender'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
    )..messageId = json['messageId'] as String;

Map<String, dynamic> _$StageTalkListItemToJson(StageTalkListItem instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'sender': instance.sender,
    };
