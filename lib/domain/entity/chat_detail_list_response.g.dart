// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_detail_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDetailListResponse _$ChatDetailListResponseFromJson(
        Map<String, dynamic> json) =>
    ChatDetailListResponse(
      pageNum: json['pageNum'] as int,
      size: json['size'] as int,
      messeges: (json['messeges'] as List<dynamic>)
          .map((e) => ChatDetailListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatDetailListResponseToJson(
        ChatDetailListResponse instance) =>
    <String, dynamic>{
      'pageNum': instance.pageNum,
      'size': instance.size,
      'messeges': instance.messeges,
    };
