// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_mvp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageMVPResponse _$StageMVPResponseFromJson(Map<String, dynamic> json) =>
    StageMVPResponse(
      mvpPlayerNum: json['mvpPlayerNum'] as int,
      playerInfos: (json['playerInfos'] as List<dynamic>)
          .map((e) =>
              StagePlayerInfoListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StageMVPResponseToJson(StageMVPResponse instance) =>
    <String, dynamic>{
      'mvpPlayerNum': instance.mvpPlayerNum,
      'playerInfos': instance.playerInfos,
    };
