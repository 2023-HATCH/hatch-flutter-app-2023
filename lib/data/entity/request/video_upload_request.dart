import 'package:json_annotation/json_annotation.dart';

part 'video_upload_request.g.dart';

@JsonSerializable()
class VideoUploadResuest {
  String title;
  String tags;

  VideoUploadResuest({
    required this.title,
    required this.tags,
  });

  factory VideoUploadResuest.fromJson(Map<String, dynamic> json) =>
      _$VideoUploadResuestFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUploadResuestToJson(this);
}
