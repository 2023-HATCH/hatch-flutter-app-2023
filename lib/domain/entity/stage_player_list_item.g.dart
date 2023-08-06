// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_player_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StagePlayerListItem _$StagePlayerListItemFromJson(Map<String, dynamic> json) =>
    StagePlayerListItem(
      playerNum: json['playerNum'] as int?,
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      profileImg: json['profileImg'] as String?,
    );

Map<String, dynamic> _$StagePlayerListItemToJson(
        StagePlayerListItem instance) =>
    <String, dynamic>{
      'playerNum': instance.playerNum,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImg': instance.profileImg,
    };
