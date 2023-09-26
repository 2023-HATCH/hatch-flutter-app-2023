import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/provider/socket_stage_error_provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketStageErrorProviderImpl extends ChangeNotifier
    implements SocketStageErrorProvider {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  StompClient? _stompClient;

  bool _isSubscribe = false;

  bool get isSubscribe => _isSubscribe;

  setIsSubscribe(bool value) {
    _isSubscribe = value;
    if (value) {
      notifyListeners();
    }
  }

  @override
  void connectWebSocket() async {
    await loginProvider.checkAccessToken();
    final accessToken = loginProvider.accessToken ?? "";

    _stompClient = StompClient(
        config: StompConfig(
      url: AppUrl.webSocketUrl,
      onConnect: (frame) {
        onSubscribe();
      },
      stompConnectHeaders: {'x-access-token': accessToken},
      webSocketConnectHeaders: {'x-access-token': accessToken},
      onDebugMessage: (p0) => debugPrint("popo socket: $p0"),
    ));
    _stompClient!.activate();
  }

  @override
  void onSubscribe() {
    _stompClient?.subscribe(
        destination: AppUrl.socketErrorUrl,
        callback: (StompFrame frame) {
          if (frame.body != null) {
            var socketResponse =
                BaseResponse.fromJson(jsonDecode(frame.body.toString()), null);
            debugPrint("mmm error: ${socketResponse.message}");
          }
        });
    setIsSubscribe(true);
  }

  @override
  void exitStage() async {
    await loginProvider.checkAccessToken();
    final accessToken = loginProvider.accessToken ?? "";

    if (_stompClient != null && (_stompClient?.isActive ?? false)) {
      _stompClient?.send(
          destination: AppUrl.socketExitUrl,
          headers: {'x-access-token': accessToken});
      _stompClient?.deactivate();
      _stompClient = null;
    }
  }
}
