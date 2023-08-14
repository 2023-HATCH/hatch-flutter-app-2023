// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_enter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageEnterResponse _$StageEnterResponseFromJson(Map<String, dynamic> json) =>
    StageEnterResponse(
      stageStatus: json['stageStatus'] as String,
      userCount: json['userCount'] as int,
      statusElapsedTime: (json['statusElapsedTime'] as num?)?.toDouble(),
      currentMusic: json['currentMusic'] == null
          ? null
          : StageMusicData.fromJson(
              json['currentMusic'] as Map<String, dynamic>),
      talkMessageData: StageTalkMessageResponse.fromJson(
          json['talkMessageData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StageEnterResponseToJson(StageEnterResponse instance) =>
    <String, dynamic>{
      'stageStatus': instance.stageStatus,
      'userCount': instance.userCount,
      'statusElapsedTime': instance.statusElapsedTime,
      'currentMusic': instance.currentMusic,
      'talkMessageData': instance.talkMessageData,
    };
