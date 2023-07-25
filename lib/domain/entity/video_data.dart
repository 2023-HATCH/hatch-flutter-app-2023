import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'video_data.g.dart';

@JsonSerializable()
class VideoData {
  final String uuid;
  final String title;
  final String tags;
  final UserData user;
  final String url;
  final int likeCount;
  final int commentCount;
  final int length;
  final DateTime createdTime;

  const VideoData({
    required this.uuid,
    required this.title,
    required this.tags,
    required this.user,
    required this.url,
    required this.likeCount,
    required this.commentCount,
    required this.length,
    required this.createdTime,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) =>
      _$VideoDataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
}
