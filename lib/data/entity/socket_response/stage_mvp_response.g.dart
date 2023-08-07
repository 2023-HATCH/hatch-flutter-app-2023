// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_mvp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageMVPResponse _$StageMVPResponseFromJson(Map<String, dynamic> json) =>
    StageMVPResponse(
      json['mvpUser'] == null
          ? null
          : StageUserListItem.fromJson(json['mvpUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StageMVPResponseToJson(StageMVPResponse instance) =>
    <String, dynamic>{
      'mvpUser': instance.mvpUser,
    };
