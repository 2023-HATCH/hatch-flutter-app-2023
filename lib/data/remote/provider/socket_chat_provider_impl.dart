import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_socket_response.dart';
import 'package:pocket_pose/data/entity/socket_request/send_chat_request.dart';
import 'package:pocket_pose/data/entity/socket_response/send_chat_response.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';
import 'package:pocket_pose/domain/provider/socket_chat_provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketChatProviderImpl extends ChangeNotifier
    implements SocketChatProvider {
  StompClient? _stompClient;
  ChatDetailListItem? _chat;

  bool _isConnect = false;
  bool _isSubscribe = false;
  bool _isChat = false;

  ChatDetailListItem? get chat => _chat;

  bool get isConnect => _isConnect;
  bool get isSubscribe => _isSubscribe;
  bool get isChat => _isChat;

  setIsConnect(bool value) {
    _isConnect = value;
    notifyListeners();
  }

  setIsSubscribe(bool value) {
    _isSubscribe = value;
    notifyListeners();
  }

  setIsChat(bool value) {
    _isChat = value;
    if (value) notifyListeners();
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
      onDebugMessage: (p0) => debugPrint("popo chat socket: $p0"),
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
            // 채팅 받기
            var socketResponse = BaseSocketResponse<SendChatResponse>.fromJson(
                jsonDecode(frame.body.toString()),
                SendChatResponse.fromJson(
                    jsonDecode(frame.body.toString())['data']));
            _chat = ChatDetailListItem(
                createdAt: socketResponse.data!.createdAt,
                sender: socketResponse.data!.sender,
                content: socketResponse.data!.content);
            setIsChat(true);
          }
        });
  }

  @override
  void sendMessage(SendChatRequest request) async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (_stompClient != null) {
      _stompClient?.send(
          destination: AppUrl.socketChatkUrl,
          headers: {'x-access-token': token},
          body: json.encode(request));
    }
  }
}
