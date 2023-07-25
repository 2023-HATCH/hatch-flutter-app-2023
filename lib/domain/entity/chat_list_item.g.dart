// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListItem _$ChatListItemFromJson(Map<String, dynamic> json) => ChatListItem(
      chatRoomId: json['chatRoomId'] as String,
      opponentUser: ChatUserListItem.fromJson(
          json['opponentUser'] as Map<String, dynamic>),
      recentContent: json['recentContent'] as String?,
    );

Map<String, dynamic> _$ChatListItemToJson(ChatListItem instance) =>
    <String, dynamic>{
      'chatRoomId': instance.chatRoomId,
      'opponentUser': instance.opponentUser,
      'recentContent': instance.recentContent,
    };
