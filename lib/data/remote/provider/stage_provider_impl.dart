import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/stage_enter_request.dart';
import 'package:pocket_pose/data/entity/response/stage_enter_response.dart';
import 'package:pocket_pose/data/entity/response/stage_user_list_response.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';
import 'package:pocket_pose/domain/entity/stage_user_list_item.dart';
import 'package:pocket_pose/domain/provider/stage_provider.dart';

class StageProviderImpl extends ChangeNotifier implements StageProvider {
  final List<StageTalkListItem> _talkList = [];
  final List<StageUserListItem> _userList = [];
  bool _isClicked = false;

  List<StageTalkListItem> get talkList => _talkList;
  List<StageUserListItem> get userList => _userList;

  bool get isClicked => _isClicked;
  setIsClicked(bool value) => _isClicked = value;

  void toggleIsLeft() {
    if (isClicked) notifyListeners();
  }

  void addTalkList(List<StageTalkListItem> list) {
    _talkList.addAll(list);
    notifyListeners();
  }

  void addTalk(StageTalkListItem talk) {
    _talkList.insert(0, talk);
    notifyListeners();
  }

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
      var responseJson = BaseResponse<StageUserListResponse>.fromJson(
          response.data, StageUserListResponse.fromJson(response.data['data']));
      _userList.clear();
      _userList.addAll(responseJson.data.list ?? []);

      notifyListeners();
      return responseJson;
    } catch (e) {
      debugPrint("mmm StageProviderImpl catch: ${e.toString()}");
    }
    return throw UnimplementedError();
  }

  @override
  Future<BaseResponse<StageEnterResponse>> getStageEnter(
      StageEnterRequest request) async {
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
      var response = await dio.get(
          '${AppUrl.stageEnterUrl}?page=${request.page}&size=${request.size}');

      var responseJson = BaseResponse<StageEnterResponse>.fromJson(
          response.data, StageEnterResponse.fromJson(response.data['data']));

      addTalkList(responseJson.data.talkMessageData.messages ?? []);

      return responseJson;
    } catch (e) {
      debugPrint("mmm StageProviderImpl catch: ${e.toString()}");
    }
    throw UnimplementedError();
  }

  @override
  Future<void> getStageCatch() async {
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
      await dio.get(AppUrl.stageCatchUrl);

      return;
    } catch (e) {
      debugPrint("mmm StageProviderImpl catch: ${e.toString()}");
      if (e.toString().contains("500")) return;
    }
    throw UnimplementedError();
  }
}
