import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/chat_room_request.dart';
import 'package:pocket_pose/data/entity/response/chat_room_response.dart';
import 'package:pocket_pose/domain/provider/chat_provider.dart';

class ChatProviderImpl extends ChangeNotifier implements ChatProvider {
  @override
  Future<BaseResponse<ChatRoomResponse>> poseChatRoom(
      ChatRoomRequest request) async {
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
      var response =
          await dio.post(AppUrl.chatRoomCreateUrl, data: jsonEncode(request));

      var responseJson = BaseResponse<ChatRoomResponse>.fromJson(
          response.data, ChatRoomResponse.fromJson(response.data['data']));

      notifyListeners();
      return responseJson;
    } catch (e) {
      debugPrint("mmm ChatProviderImpl catch: ${e.toString()}");
    }
    throw UnimplementedError();
  }
}
