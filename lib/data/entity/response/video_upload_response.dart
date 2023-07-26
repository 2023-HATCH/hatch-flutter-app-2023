import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';

part 'video_upload_response.g.dart';

@JsonSerializable()
class VideoUploadResponse extends BaseObject<VideoUploadResponse> {
  String uuid;

  VideoUploadResponse({
    required this.uuid,
  });

  factory VideoUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUploadResponseToJson(this);

  @override
  VideoUploadResponse fromJson(json) {
    return VideoUploadResponse.fromJson(json);
  }
}
