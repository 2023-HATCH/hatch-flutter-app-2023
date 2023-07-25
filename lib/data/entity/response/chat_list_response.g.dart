// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListResponse _$ChatListResponseFromJson(Map<String, dynamic> json) =>
    ChatListResponse(
      list: (json['list'] as List<dynamic>)
          .map((e) => ChatListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatListResponseToJson(ChatListResponse instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
