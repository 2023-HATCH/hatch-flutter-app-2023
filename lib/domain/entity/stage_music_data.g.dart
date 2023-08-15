// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_music_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageMusicData _$StageMusicDataFromJson(Map<String, dynamic> json) =>
    StageMusicData(
      musicId: json['musicId'] as String,
      title: json['title'] as String,
      singer: json['singer'] as String,
      length: json['length'] as int,
      musicUrl: json['musicUrl'] as String,
      concept: json['concept'] as String,
    );

Map<String, dynamic> _$StageMusicDataToJson(StageMusicData instance) =>
    <String, dynamic>{
      'musicId': instance.musicId,
      'title': instance.title,
      'singer': instance.singer,
      'length': instance.length,
      'musicUrl': instance.musicUrl,
      'concept': instance.concept,
    };
