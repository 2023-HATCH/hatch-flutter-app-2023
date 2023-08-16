import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/domain/provider/socket_chat_provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketChatProviderImpl extends ChangeNotifier
    implements SocketChatProvider {
  StompClient? _stompClient;

  bool _isConnect = false;
  bool _isSubscribe = false;

  bool get isConnect => _isConnect;
  bool get isSubscribe => _isSubscribe;

  setIsConnect(bool value) {
    _isConnect = value;
    notifyListeners();
  }

  setIsSubscribe(bool value) {
    _isSubscribe = value;
    print("mmm 구독 완");
    notifyListeners();
  }

  @override
  void connectWebSocket() async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    _stompClient = StompClient(
        config: StompConfig(
      url: AppUrl.webSocketUrl,
      onConnect: (frame) {
        setIsConnect(true);
      },
      stompConnectHeaders: {'x-access-token': token},
      webSocketConnectHeaders: {'x-access-token': token},
      onDebugMessage: (p0) => print("popo chat socket: $p0"),
    ));
    _stompClient!.activate();
  }

  @override
  void onSubscribe(String chatRoomId) {
    _stompClient?.subscribe(
        destination: "${AppUrl.socketSubscribeChatUrl}/$chatRoomId",
        callback: (StompFrame frame) {
          if (frame.body != null) {
            setIsSubscribe(true);
          }
        });
  }
}
