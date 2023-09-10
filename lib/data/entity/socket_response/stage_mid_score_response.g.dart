// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_mid_score_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageMidScoreResponse _$StageMidScoreResponseFromJson(
        Map<String, dynamic> json) =>
    StageMidScoreResponse(
      mvpPlayerNum: json['mvpPlayerNum'] as int,
      playerInfos: (json['playerInfos'] as List<dynamic>)
          .map((e) =>
              StagePlayerInfoListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StageMidScoreResponseToJson(
        StageMidScoreResponse instance) =>
    <String, dynamic>{
      'mvpPlayerNum': instance.mvpPlayerNum,
      'playerInfos': instance.playerInfos,
    };
