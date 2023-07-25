// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoData _$VideoDataFromJson(Map<String, dynamic> json) => VideoData(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      tags: json['tags'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      url: json['url'] as String,
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      length: json['length'] as int,
      createdTime: DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'tags': instance.tags,
      'user': instance.user,
      'url': instance.url,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'length': instance.length,
      'createdTime': instance.createdTime.toIso8601String(),
    };
