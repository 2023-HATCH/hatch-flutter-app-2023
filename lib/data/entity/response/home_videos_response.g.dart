// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_videos_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeVideosResponse _$HomeVideosResponseFromJson(Map<String, dynamic> json) =>
    HomeVideosResponse(
      videoList: (json['videoList'] as List<dynamic>)
          .map((e) => VideoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLast: json['isLast'] as bool,
    );

Map<String, dynamic> _$HomeVideosResponseToJson(HomeVideosResponse instance) =>
    <String, dynamic>{
      'videoList': instance.videoList,
      'isLast': instance.isLast,
    };
