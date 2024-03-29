import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/stage_talk_message_request.dart';
import 'package:pocket_pose/data/entity/response/stage_talk_message_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/repository/stage_talk_repository.dart';

class StageTalkRepositoryImpl implements StageTalkRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  @override
  Future<BaseResponse<StageTalkMessageResponse>> getTalkMessages(
      StageTalkMessageRequest request) async {
    await loginProvider.checkAccessToken();
    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    var dio = Dio();
    try {
      dio.options.headers = {
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
      };
      dio.options.contentType = "application/json";
      var response = await dio.get(
          '${AppUrl.stageTalkUrl}?page=${request.page}&size=${request.size}');

      return BaseResponse<StageTalkMessageResponse>.fromJson(response.data,
          StageTalkMessageResponse.fromJson(response.data['data']));
    } catch (e) {
      debugPrint("mmm StageTalkProviderImpl catch: ${e.toString()}");
    }
    return throw UnimplementedError();
  }
}
