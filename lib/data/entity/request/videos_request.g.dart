// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideosRequest _$VideosRequestFromJson(Map<String, dynamic> json) =>
    VideosRequest(
      page: json['page'] as int,
      size: json['size'] as int,
    );

Map<String, dynamic> _$VideosRequestToJson(VideosRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
    };
