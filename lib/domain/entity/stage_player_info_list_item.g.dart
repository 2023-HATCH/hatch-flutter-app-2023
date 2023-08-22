// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_player_info_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StagePlayerInfoListItem _$StagePlayerInfoListItemFromJson(
        Map<String, dynamic> json) =>
    StagePlayerInfoListItem(
      playerNum: json['playerNum'] as int,
      similarity: (json['similarity'] as num).toDouble(),
      player: UserListItem.fromJson(json['player'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StagePlayerInfoListItemToJson(
        StagePlayerInfoListItem instance) =>
    <String, dynamic>{
      'playerNum': instance.playerNum,
      'similarity': instance.similarity,
      'player': instance.player,
    };
