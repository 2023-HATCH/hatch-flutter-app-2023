// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: unused_element
UserListItem _$UserListItemFromJson(Map<String, dynamic> json) => UserListItem(
      json['userId'] as String,
      json['nickname'] as String,
      json['profileImg'] as String?,
    );

Map<String, dynamic> _$UserListItemToJson(UserListItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImg': instance.profileImg,
    };
