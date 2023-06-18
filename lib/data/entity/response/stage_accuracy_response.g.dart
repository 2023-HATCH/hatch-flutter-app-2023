// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_accuracy_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageAccuracyResponse _$StageAccuracyResponseFromJson(
        Map<String, dynamic> json) =>
    StageAccuracyResponse(
      data: StageAccuracyData.fromJson(json['data'] as Map<String, dynamic>),
      timeStamp: json['timeStamp'] as String,
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$StageAccuracyResponseToJson(
        StageAccuracyResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'timeStamp': instance.timeStamp,
      'code': instance.code,
      'message': instance.message,
    };
