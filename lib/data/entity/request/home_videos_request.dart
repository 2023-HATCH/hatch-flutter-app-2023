import 'package:json_annotation/json_annotation.dart';

part 'home_videos_request.g.dart';

@JsonSerializable()
class HomeVideosRequest {
  final int page;
  final int size;

  const HomeVideosRequest({
    required this.page,
    required this.size,
  });

  factory HomeVideosRequest.fromJson(Map<String, dynamic> json) =>
      _$HomeVideosRequestFromJson(json);
  Map<String, dynamic> toJson() => _$HomeVideosRequestToJson(this);
}
