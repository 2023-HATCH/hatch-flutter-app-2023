// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomListItem _$ChatRoomListItemFromJson(Map<String, dynamic> json) =>
    ChatRoomListItem(
      chatRoomId: json['chatRoomId'] as String,
      opponentUser:
          UserListItem.fromJson(json['opponentUser'] as Map<String, dynamic>),
      recentContent: json['recentContent'] as String?,
      recentSendAt: json['recentSendAt'] as String?,
    );

Map<String, dynamic> _$ChatRoomListItemToJson(ChatRoomListItem instance) =>
    <String, dynamic>{
      'chatRoomId': instance.chatRoomId,
      'opponentUser': instance.opponentUser,
      'recentContent': instance.recentContent,
      'recentSendAt': instance.recentSendAt,
    };
