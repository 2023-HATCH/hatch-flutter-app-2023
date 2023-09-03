import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/response/share_response.dart';
import 'package:pocket_pose/domain/repository/share_repository.dart';

class ShareRepositoryImpl implements ShareRepository {
  @override
  Future<BaseResponse<ShareResponse>> putChatRoom(String videoId) async {
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
      var response = await dio.put('${AppUrl.videoUrl}/$videoId');

      var responseJson = BaseResponse<ShareResponse>.fromJson(
          response.data, ShareResponse.fromJson(response.data['data']));

      return responseJson;
    } catch (e) {
      debugPrint("mmm ShareRepositoryImpl catch: ${e.toString()}");
    }
    throw UnimplementedError();
  }
}
