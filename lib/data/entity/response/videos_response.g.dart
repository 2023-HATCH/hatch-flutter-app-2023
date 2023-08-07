// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosResponse _$VideosResponseFromJson(Map<String, dynamic> json) =>
    VideosResponse(
      videoList: (json['videoList'] as List<dynamic>)
          .map((e) => VideoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLast: json['isLast'] as bool,
    );

Map<String, dynamic> _$VideosResponseToJson(VideosResponse instance) =>
    <String, dynamic>{
      'videoList': instance.videoList,
      'isLast': instance.isLast,
    };
