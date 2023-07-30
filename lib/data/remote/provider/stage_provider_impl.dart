import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/response/stage_user_list_response.dart';
import 'package:pocket_pose/domain/provider/stage_provider.dart';

class StageProviderImpl implements StageProvider {
  @override
  Future<BaseResponse<StageUserListResponse>> getUserList() async {
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
      var response = await dio.get(AppUrl.stageUserListUrl);

      print('mmm resp: ${response.data}');

      return BaseResponse<StageUserListResponse>.fromJson(
          response.data, StageUserListResponse.fromJson(response.data['data']));
    } catch (e) {
      debugPrint("mmm StageProviderImpl catch: ${e.toString()}");
    }
    return throw UnimplementedError();
  }
}
