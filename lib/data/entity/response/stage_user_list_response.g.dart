// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_user_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageUserListResponse _$StageUserListResponseFromJson(
        Map<String, dynamic> json) =>
    StageUserListResponse(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => StageUserListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StageUserListResponseToJson(
        StageUserListResponse instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
