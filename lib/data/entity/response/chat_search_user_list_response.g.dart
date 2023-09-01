// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_search_user_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSearchUserListResponse _$ChatSearchUserListResponseFromJson(
        Map<String, dynamic> json) =>
    ChatSearchUserListResponse(
      userList: (json['userList'] as List<dynamic>)
          .map((e) => ChatUserListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatSearchUserListResponseToJson(
        ChatSearchUserListResponse instance) =>
    <String, dynamic>{
      'userList': instance.userList,
    };
