// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListResponse _$ChatListResponseFromJson(Map<String, dynamic> json) =>
    ChatListResponse(
      chatRooms: (json['chatRooms'] as List<dynamic>)
          .map((e) => ChatRoomListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatListResponseToJson(ChatListResponse instance) =>
    <String, dynamic>{
      'chatRooms': instance.chatRooms,
    };
