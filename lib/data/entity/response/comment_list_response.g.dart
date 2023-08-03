// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentListResponse _$CommentListResponseFromJson(Map<String, dynamic> json) =>
    CommentListResponse(
      commentList: (json['commentList'] as List<dynamic>)
          .map((e) => CommentData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentListResponseToJson(
        CommentListResponse instance) =>
    <String, dynamic>{
      'commentList': instance.commentList,
    };
