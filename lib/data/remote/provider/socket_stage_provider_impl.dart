import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_socket_response.dart';
import 'package:pocket_pose/data/entity/socket_request/send_skeleton_request.dart';
import 'package:pocket_pose/data/entity/socket_response/catch_end_response.dart';
import 'package:pocket_pose/data/entity/socket_response/talk_message_response.dart';
import 'package:pocket_pose/data/entity/socket_response/user_count_response.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';
import 'package:pocket_pose/domain/provider/socket_stage_provider.dart';
import 'package:pocket_pose/ui/view/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/popo_play_view.dart';
import 'package:pocket_pose/ui/view/popo_result_view.dart';
import 'package:pocket_pose/ui/view/popo_wait_view.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

enum StageType {
  WAIT, // only front
  CATCH_START,
  CATCH_END,
  PLAY_START,
  MVP_START,
  USER_COUNT,
  STAGE_ROUTINE_STOP,
  TALK_MESSAGE,
  TALK_REACTION,
  PLAY_SKELETON
}

class SocketStageProviderImpl extends ChangeNotifier
    implements SocketStageProvider {
  StompClient? _stompClient;

  int _userCount = 0;
  final List<StagePlayerListItem> _players = [];
  StageTalkListItem? _talk;
  Map<PoseLandmarkType, PoseLandmark>? player0;
  Map<PoseLandmarkType, PoseLandmark>? player1;
  Map<PoseLandmarkType, PoseLandmark>? player2;

  StageType _stageType = StageType.WAIT;
  bool _isConnect = false;
  bool _isSubscribe = false;
  bool _isTalk = false;
  bool _isReaction = false;
  bool _isUserCountChange = false;
  bool _isPlaySkeletonChange = false;

  int get userCount => _userCount;
  StageTalkListItem? get talk => _talk;

  StageType get stageType => _stageType;
  bool get isConnect => _isConnect;
  bool get isSubscribe => _isSubscribe;
  bool get isTalk => _isTalk;
  bool get isReaction => _isReaction;
  bool get isUserCountChange => _isUserCountChange;
  bool get isPlaySkeletonChange => _isPlaySkeletonChange;

  bool get isMVPStart => stageType == StageType.MVP_START;

  setTalk(StageTalkListItem value) {
    _talk = value;
    notifyListeners();
  }

  setUserCount(int value) {
    _userCount = value;
    notifyListeners();
  }

  setIsSubscribe(bool value) {
    _isSubscribe = value;
    notifyListeners();
  }

  setIsUserCountChange(bool value) {
    _isUserCountChange = value;
    if (value) notifyListeners();
  }

  setIsPlaySkeletonChange(bool value) {
    _isPlaySkeletonChange = value;
    if (value) notifyListeners();
  }

  setIsTalk(bool value) {
    _isTalk = value;
    if (value) notifyListeners();
  }

  setIsReaction(bool value) {
    _isReaction = value;
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
        _isConnect = true;
        notifyListeners();
      },
      stompConnectHeaders: {'x-access-token': token},
      webSocketConnectHeaders: {'x-access-token': token},
      onDebugMessage: (p0) => print("mmm socket: $p0"),
    ));
    _stompClient!.activate();
  }

  @override
  void deactivateWebSocket() {
    _stompClient?.deactivate();
  }

  @override
  void onSubscribe() {
    _stompClient?.subscribe(
        destination: AppUrl.socketSubscribeStageUrl,
        callback: (StompFrame frame) {
          if (frame.body != null) {
            setIsSubscribe(true);
            // stage 상태 변경
            var socketResponse = BaseSocketResponse.fromJson(
                jsonDecode(frame.body.toString()), null);
            _setStageType(socketResponse, frame);
          }
        });
  }

  @override
  void sendMessage(String message) async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (_stompClient != null) {
      _stompClient?.send(
          destination: AppUrl.socketTalkUrl,
          headers: {'x-access-token': token},
          body: json.encode({"content": message}));
    }
  }

  @override
  void sendReaction() async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (_stompClient != null) {
      _stompClient?.send(
        destination: AppUrl.socketReactionUrl,
        headers: {'x-access-token': token},
      );
    }
  }

  @override
  void sendSkeleton(SendSkeletonRequest request) async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (_stompClient != null && (_stompClient?.isActive ?? false)) {
      _stompClient?.send(
          destination: AppUrl.socketSkeletonUrl,
          headers: {'x-access-token': token},
          body: json.encode(request));
    }
  }

  void _setStageType(BaseSocketResponse response, StompFrame frame) {
    switch (response.type) {
      case StageType.USER_COUNT:
        var socketResponse = BaseSocketResponse<UserCountResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            UserCountResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));

        setUserCount(socketResponse.data!.userCount);
        setIsUserCountChange(true);
        break;
      case StageType.TALK_MESSAGE:
        var socketResponse = BaseSocketResponse<TalkMessageResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            TalkMessageResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));

        var talk = StageTalkListItem(
            content: socketResponse.data!.content,
            sender: socketResponse.data!.sender);

        setTalk(talk);
        setIsTalk(true);
        break;
      case StageType.TALK_REACTION:
        setIsReaction(true);
        break;
      case StageType.CATCH_END:
        var socketResponse = BaseSocketResponse<CatchEndResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            CatchEndResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));
        _players.clear();
        _players.addAll(socketResponse.data?.players ?? []);
        break;
      case StageType.PLAY_SKELETON:
        print("mmm 답이왔어요");
        // var socketResponse = BaseSocketResponse<SendSkeletonResponse>.fromJson(
        //     jsonDecode(frame.body.toString()),
        //     SendSkeletonResponse.fromJson(
        //         jsonDecode(frame.body.toString())['data']));
        // switch (socketResponse.data?.playerNum) {
        //   case 0:
        //     player0 = socketResponse.data?.skeleton;
        //     break;
        //   case 1:
        //     player1 = socketResponse.data?.skeleton;
        //     break;
        //   case 2:
        //     player2 = socketResponse.data?.skeleton;
        //     break;
        // }
        // setIsPlaySkeletonChange(true);
        break;
      default:
        _stageType = response.type;
    }
  }

  Widget buildStageView(StageType type) {
    switch (type) {
      case StageType.STAGE_ROUTINE_STOP:
      case StageType.WAIT:
        return const PoPoWaitView();
      case StageType.CATCH_START:
        return const PoPoCatchView();
      case StageType.PLAY_START:
        return PoPoPlayView(
            isResultState: _stageType == StageType.MVP_START,
            players: _players);
      case StageType.MVP_START:
        return PoPoResultView(isResultState: _stageType == StageType.MVP_START);
      default:
        return const PoPoWaitView();
    }
  }
}
