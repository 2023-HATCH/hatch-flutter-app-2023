// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomListResponse _$ChatRoomListResponseFromJson(
        Map<String, dynamic> json) =>
    ChatRoomListResponse(
      chatRooms: (json['chatRooms'] as List<dynamic>)
          .map((e) => ChatRoomListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatRoomListResponseToJson(
        ChatRoomListResponse instance) =>
    <String, dynamic>{
      'chatRooms': instance.chatRooms,
    };
