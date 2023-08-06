// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoData _$VideoDataFromJson(Map<String, dynamic> json) => VideoData(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      videoUrl: json['videoUrl'] as String,
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      length: json['length'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      liked: json['liked'] as bool,
    );

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'tag': instance.tag,
      'user': instance.user,
      'videoUrl': instance.videoUrl,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'length': instance.length,
      'createdAt': instance.createdAt.toIso8601String(),
      'liked': instance.liked,
    };
