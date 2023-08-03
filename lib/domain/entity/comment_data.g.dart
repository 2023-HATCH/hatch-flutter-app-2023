// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentData _$CommentDataFromJson(Map<String, dynamic> json) => CommentData(
      uuid: json['uuid'] as String,
      content: json['content'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'content': instance.content,
      'user': instance.user,
      'createdAt': instance.createdAt.toIso8601String(),
    };
