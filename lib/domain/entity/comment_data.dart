import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'comment_data.g.dart';

@JsonSerializable()
class CommentData {
  final String uuid;
  final String content;
  final UserData user;
  final DateTime createdAt;

  const CommentData({
    required this.uuid,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);
  Map<String, dynamic> toJson() => _$CommentDataToJson(this);
}
