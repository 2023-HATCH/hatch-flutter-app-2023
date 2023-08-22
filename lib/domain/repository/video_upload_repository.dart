import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/video_upload_request.dart';
import 'package:pocket_pose/data/entity/response/video_upload_response.dart';

abstract class VideoUploadRepository {
  Future<BaseResponse<VideoUploadResponse>> postVideoUpload(
      VideoUploadRequest request);
}
