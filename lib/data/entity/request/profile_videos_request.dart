import 'package:json_annotation/json_annotation.dart';

part 'profile_videos_request.g.dart';

@JsonSerializable()
class ProfileVideosRequest {
  final String userId;
  final int page;
  final int size;

  const ProfileVideosRequest({
    required this.userId,
    required this.page,
    required this.size,
  });

  factory ProfileVideosRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileVideosRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileVideosRequestToJson(this);
}
