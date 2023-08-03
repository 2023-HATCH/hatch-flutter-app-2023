import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'comment_list_response.g.dart';

@JsonSerializable()
class CommentListResponse {
  final String uuid;
  final String content;
  final UserData user;
  final DateTime createdAt;

  const CommentListResponse({
    required this.uuid,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CommentListResponseToJson(this);
}
