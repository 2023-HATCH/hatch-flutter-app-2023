import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';

part 'videos_response.g.dart';

@JsonSerializable()
class VideosResponse {
  final List<VideoData> videoList;
  final bool isLast;

  const VideosResponse({
    required this.videoList,
    required this.isLast,
  });

  factory VideosResponse.fromJson(Map<String, dynamic> json) =>
      _$VideosResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VideosResponseToJson(this);
}
