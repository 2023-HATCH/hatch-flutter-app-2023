// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catch_end_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatchEndResponse _$CatchEndResponseFromJson(Map<String, dynamic> json) =>
    CatchEndResponse(
      players: (json['players'] as List<dynamic>)
          .map((e) => StagePlayerListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CatchEndResponseToJson(CatchEndResponse instance) =>
    <String, dynamic>{
      'players': instance.players,
    };
