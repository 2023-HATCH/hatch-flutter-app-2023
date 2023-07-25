import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';

part 'home_videos_response.g.dart';

@JsonSerializable()
class HomeVideosResponse {
  final List<VideoData> videoList;
  final bool isLast;

  const HomeVideosResponse({
    required this.videoList,
    required this.isLast,
  });

  factory HomeVideosResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeVideosResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HomeVideosResponseToJson(this);
}
