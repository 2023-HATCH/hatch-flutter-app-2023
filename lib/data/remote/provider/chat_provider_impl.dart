import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/chat_room_request.dart';
import 'package:pocket_pose/data/entity/response/chat_room_list_response.dart';
import 'package:pocket_pose/data/entity/response/chat_room_response.dart';
import 'package:pocket_pose/domain/entity/chat_room_list_item.dart';
import 'package:pocket_pose/domain/provider/chat_provider.dart';

class ChatProviderImpl extends ChangeNotifier implements ChatProvider {
  final List<ChatRoomListItem> _chatRooms = [];

  List<ChatRoomListItem> get chatRooms => _chatRooms;

  setChatRooms(List<ChatRoomListItem> list) {
    _chatRooms.addAll(list);
    notifyListeners();
  }

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
          await dio.post(AppUrl.chatRoomUrl, data: jsonEncode(request));

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

      setChatRooms(responseJson.data.chatRooms);

      return responseJson;
    } catch (e) {
      debugPrint("mmm ChatProviderImpl catch: ${e.toString()}");
    }
    throw UnimplementedError();
  }
}
