import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/comment_data.dart';

part 'comment_list_response.g.dart';

@JsonSerializable()
class CommentListResponse {
  final List<CommentData> commentList;

  const CommentListResponse({
    required this.commentList,
  });

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CommentListResponseToJson(this);
}
