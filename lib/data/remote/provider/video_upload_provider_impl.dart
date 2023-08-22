import 'dart:async';

import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/video_upload_request.dart';
import 'package:pocket_pose/data/entity/response/video_upload_response.dart';
import 'package:pocket_pose/data/remote/repository/video_upload_repository_impl.dart';
import 'package:pocket_pose/domain/provider/video_upload_provider.dart';

class VideoUploadProviderImpl implements VideoUploadProvider {
  final VideoUploadRepositoryImpl _videoUploadRepository =
      VideoUploadRepositoryImpl();
  @override
  Future<BaseResponse<VideoUploadResponse>> postVideoUpload(
      VideoUploadRequest request) async {
    return await _videoUploadRepository.postVideoUpload(request);
  }
}
