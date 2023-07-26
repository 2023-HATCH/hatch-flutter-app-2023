// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_talk_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageTalkMessageResponse _$StageTalkMessageResponseFromJson(
        Map<String, dynamic> json) =>
    StageTalkMessageResponse(
      page: json['page'] as int,
      size: json['size'] as int,
      messeges: (json['messeges'] as List<dynamic>)
          .map((e) => StageTalkListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StageTalkMessageResponseToJson(
        StageTalkMessageResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'messeges': instance.messeges,
    };
