// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_upload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoUploadRequest _$VideoUploadRequestFromJson(Map<String, dynamic> json) =>
    VideoUploadRequest(
      title: json['title'] as String,
      tags: json['tags'] as String,
      videoPath: json['videoPath'] as String,
    );

Map<String, dynamic> _$VideoUploadRequestToJson(VideoUploadRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'tags': instance.tags,
      'videoPath': instance.videoPath,
    };
