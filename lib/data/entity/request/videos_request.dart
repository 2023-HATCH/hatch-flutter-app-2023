import 'package:json_annotation/json_annotation.dart';

part 'videos_request.g.dart';

@JsonSerializable()
class VideosRequest {
  final int page;
  final int size;

  const VideosRequest({
    required this.page,
    required this.size,
  });

  factory VideosRequest.fromJson(Map<String, dynamic> json) =>
      _$VideosRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VideosRequestToJson(this);
}
