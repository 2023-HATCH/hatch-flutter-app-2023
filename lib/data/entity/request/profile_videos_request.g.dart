// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_videos_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileVideosRequest _$ProfileVideosRequestFromJson(
        Map<String, dynamic> json) =>
    ProfileVideosRequest(
      userId: json['userId'] as String,
      page: json['page'] as int,
      size: json['size'] as int,
    );

Map<String, dynamic> _$ProfileVideosRequestToJson(
        ProfileVideosRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'page': instance.page,
      'size': instance.size,
    };
