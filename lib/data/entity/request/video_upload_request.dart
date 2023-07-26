import 'package:json_annotation/json_annotation.dart';

part 'video_upload_request.g.dart';

@JsonSerializable()
class VideoUploadRequest {
  String title;
  String tags;
  String videoPath;

  VideoUploadRequest({
    required this.title,
    required this.tags,
    required this.videoPath,
  });

  factory VideoUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$VideoUploadRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUploadRequestToJson(this);
}
