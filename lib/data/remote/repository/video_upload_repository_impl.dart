import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/video_upload_request.dart';
import 'package:pocket_pose/data/entity/response/video_upload_response.dart';
import 'package:pocket_pose/domain/repository/video_upload_repository.dart';

class VideoUploadRepositoryImpl implements VideoUploadRepository {
  @override
  Future<BaseResponse<VideoUploadResponse>> postVideoUpload(
      VideoUploadRequest request) async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    const refreshTokenKey = 'kakaoRefreshToken';
    String accessToken = await storage.read(key: storageKey) ?? "";
    String refreshToken = await storage.read(key: refreshTokenKey) ?? "";

    var dio = Dio();
    try {
      dio.options.headers = {
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
      };
      dio.options.contentType = "application/json";
      FormData formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(request.videoPath),
      });
      var response = await dio.post(
          '${AppUrl.videoUrl}?title=${request.title}&tag=${request.tags}',
          data: formData);

      return BaseResponse<VideoUploadResponse>.fromJson(
          response.data, VideoUploadResponse.fromJson(response.data['data']));
    } catch (e) {
      debugPrint("mmm VideoUploadProviderImpl catch: ${e.toString()}");
    }
    return throw UnimplementedError();
  }
}
