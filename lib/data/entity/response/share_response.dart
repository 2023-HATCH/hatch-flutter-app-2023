import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'share_response.g.dart';

@JsonSerializable()
class ShareResponse extends BaseObject<ShareResponse> {
  final String uuid;
  final String title;
  final String tag;
  final UserData user;
  final String videoUrl;
  final String thumbnailUrl;
  late int likeCount;
  late int commentCount;
  final int length;
  final DateTime createdAt;
  late bool liked;
  final int viewCount;

  ShareResponse({
    required this.uuid,
    required this.title,
    required this.tag,
    required this.user,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.likeCount,
    required this.commentCount,
    required this.length,
    required this.createdAt,
    required this.liked,
    required this.viewCount,
  });

  factory ShareResponse.fromJson(Map<String, dynamic> json) =>
      _$ShareResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShareResponseToJson(this);

  @override
  ShareResponse fromJson(json) {
    return ShareResponse.fromJson(json);
  }
}
