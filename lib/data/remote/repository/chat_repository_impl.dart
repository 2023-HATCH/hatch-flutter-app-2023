import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/chat_room_request.dart';
import 'package:pocket_pose/data/entity/response/chat_detail_list_response.dart';
import 'package:pocket_pose/data/entity/response/chat_room_list_response.dart';
import 'package:pocket_pose/data/entity/response/chat_room_response.dart';
import 'package:pocket_pose/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<BaseResponse<ChatRoomResponse>> putChatRoom(
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
      var response = await dio.put('${AppUrl.chatRoomUrl}?size=5',
          data: jsonEncode(request));

      var responseJson = BaseResponse<ChatRoomResponse>.fromJson(
          response.data, ChatRoomResponse.fromJson(response.data['data']));

      return responseJson;
    } catch (e) {
      debugPrint("mmm ChatProviderImpl catch: ${e.toString()}");
    }
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<ChatRoomListResponse>> getChatRoomList() async {
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
      var response = await dio.get(AppUrl.chatRoomUrl);

      var responseJson = BaseResponse<ChatRoomListResponse>.fromJson(
          response.data, ChatRoomListResponse.fromJson(response.data['data']));

      return responseJson;
    } catch (e) {
      debugPrint("mmm ChatProviderImpl catch: ${e.toString()}");
    }
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<ChatDetailListResponse>> getChatDetailList(
      String chatRoomId, int page) async {
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
      var response = await dio
          .get('${AppUrl.chatRoomUrl}/$chatRoomId/messages?page=$page&size=15');

      var responseJson = BaseResponse<ChatDetailListResponse>.fromJson(
          response.data,
          ChatDetailListResponse.fromJson(response.data['data']));

      return responseJson;
    } catch (e) {
      debugPrint("mmm ChatProviderImpl catch: ${e.toString()}");
    }
    throw UnimplementedError();
  }
}
