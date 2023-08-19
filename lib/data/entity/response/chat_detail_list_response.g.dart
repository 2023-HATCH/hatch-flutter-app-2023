// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_detail_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDetailListResponse _$ChatDetailListResponseFromJson(
        Map<String, dynamic> json) =>
    ChatDetailListResponse(
      page: json['page'] as int,
      size: json['size'] as int,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatDetailListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatDetailListResponseToJson(
        ChatDetailListResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'messages': instance.messages,
    };
