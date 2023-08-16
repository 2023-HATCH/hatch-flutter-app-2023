// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_talk_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageTalkListItem _$StageTalkListItemFromJson(Map<String, dynamic> json) =>
    StageTalkListItem(
      messageId: json['messageId'] as String?,
      content: json['content'] as String,
      sender: UserListItem.fromJson(json['sender'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$StageTalkListItemToJson(StageTalkListItem instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'sender': instance.sender,
    };
