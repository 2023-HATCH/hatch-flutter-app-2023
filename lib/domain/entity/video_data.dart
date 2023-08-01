import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'video_data.g.dart';

@JsonSerializable()
class VideoData {
  final String uuid;
  final String title;
  final String tag;
  final UserData user;
  final String videoUrl;
  final int likeCount;
  final int commentCount;
  final int length;
  final DateTime createdAt;

  const VideoData({
    required this.uuid,
    required this.title,
    required this.tag,
    required this.user,
    required this.videoUrl,
    required this.likeCount,
    required this.commentCount,
    required this.length,
    required this.createdAt,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) =>
      _$VideoDataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
}
