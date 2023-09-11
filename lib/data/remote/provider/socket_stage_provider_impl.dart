// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/base_socket_response.dart';
import 'package:pocket_pose/data/entity/socket_request/send_skeleton_request.dart';
import 'package:pocket_pose/data/entity/socket_response/catch_end_response.dart';
import 'package:pocket_pose/data/entity/socket_response/catch_start_response.dart';
import 'package:pocket_pose/data/entity/socket_response/send_skeleton_response.dart';
import 'package:pocket_pose/data/entity/socket_response/stage_mvp_response.dart';
import 'package:pocket_pose/data/entity/socket_response/talk_message_response.dart';
import 'package:pocket_pose/data/entity/socket_response/user_count_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/stage_music_data.dart';
import 'package:pocket_pose/domain/entity/stage_player_info_list_item.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';
import 'package:pocket_pose/domain/provider/socket_stage_provider.dart';
import 'package:pocket_pose/ui/view/stage/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/stage/popo_play_view.dart';
import 'package:pocket_pose/ui/view/stage/popo_result_view.dart';
import 'package:pocket_pose/ui/view/stage/popo_wait_view.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

enum SocketType {
  WAIT,
  CATCH,
  PLAY,
  MVP,
  CATCH_START,
  CATCH_END_RESTART,
  CATCH_END,
  PLAY_START,
  PLAY_SKELETON,
  PLAY_END,
  MVP_START,
  MVP_SKELETON,
  MVP_END,
  USER_COUNT,
  STAGE_ROUTINE_STOP,
  TALK_MESSAGE,
  TALK_REACTION,

  CHAT_MESSAGE,
}

final socketTypeList = [
  "WAIT",
  "CATCH",
  "PLAY",
  "MVP",
  "CATCH_START",
  "CATCH_END_RESTART",
  "CATCH_END",
  "PLAY_START",
  "PLAY_SKELETON",
  "PLAY_END",
  "MVP_START",
  "MVP_SKELETON",
  "MVP_END",
  "USER_COUNT",
  "STAGE_ROUTINE_STOP",
  "TALK_MESSAGE",
  "TALK_REACTION",
];

class SocketStageProviderImpl extends ChangeNotifier
    implements SocketStageProvider {
  final _navigatorKey = GlobalKey<NavigatorState>();
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  String? _userId;
  StompClient? _stompClient;
  StageMusicData? _catchMusicData;

  int _userCount = 0;
  final List<StagePlayerListItem> _players = [];
  StagePlayerListItem? _mvp;
  List<StagePlayerInfoListItem> _playerInfos = [];
  StageTalkListItem? _talk;
  Map<PoseLandmarkType, PoseLandmark>? player0;
  Map<PoseLandmarkType, PoseLandmark>? player1;
  Map<PoseLandmarkType, PoseLandmark>? player2;
  Map<PoseLandmarkType, PoseLandmark>? mvpSkeleton;

  SocketType _socketType = SocketType.WAIT;
  bool _isConnect = false;
  // bool _isTalk = false;
  bool _isReaction = false;
  bool _isCatchMidEnter = false;
  bool _isReCatch = false;
  bool _isPlaySkeletonChange = false;
  bool _isMVPSkeletonChange = false;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? get userId => _userId;
  StageMusicData? get catchMusicData => _catchMusicData;
  int get userCount => _userCount;
  List<StagePlayerInfoListItem> get playerInfos => _playerInfos;
  StageTalkListItem? get talk => _talk;

  List<StagePlayerListItem> get players => _players;
  SocketType get stageType => _socketType;
  bool get isConnect => _isConnect;
  // bool get isTalk => _isTalk;
  bool get isReaction => _isReaction;
  bool get isCatchMidEnter => _isCatchMidEnter;
  bool get isReCatch => _isReCatch;
  bool get isPlaySkeletonChange => _isPlaySkeletonChange;
  bool get isMVPSkeletonChange => _isMVPSkeletonChange;

  setUserId(String id) {
    _userId = id;
  }

  setTalk(StageTalkListItem value) {
    _talk = value;
    notifyListeners();
  }

  setUserCount(int value) {
    _userCount = value;
    notifyListeners();
  }

  setIsConnect(bool value) {
    _isConnect = value;
    if (value) notifyListeners();
  }

  setIsCatchMidEnter(bool value) {
    _isCatchMidEnter = value;
    if (value) notifyListeners();
  }

  setIsReCatch(bool value) {
    _isReCatch = value;
    notifyListeners();
  }

  setIsPlaySkeletonChange(bool value) {
    _isPlaySkeletonChange = value;
    if (value) notifyListeners();
  }

  setIsMVPSkeletonChange(bool value) {
    _isMVPSkeletonChange = value;
    if (value) notifyListeners();
  }

  // setIsTalk(bool value) {
  //   _isTalk = value;
  //   if (value) notifyListeners();
  // }

  setIsReaction(bool value) {
    _isReaction = value;
    if (value) notifyListeners();
  }

  @override
  void connectWebSocket() async {
    await loginProvider.checkAccessToken();
    final accessToken = loginProvider.accessToken ?? "";

    _stompClient = StompClient(
        config: StompConfig(
      url: AppUrl.webSocketUrl,
      onConnect: (frame) {
        setIsConnect(true);
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
        destination: AppUrl.socketSubscribeStageUrl,
        callback: (StompFrame frame) {
          if (frame.body != null) {
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
  void sendPlaySkeleton(SendSkeletonRequest request) async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (_stompClient != null && (_stompClient?.isActive ?? false)) {
      _stompClient?.send(
          destination: AppUrl.socketPlaySkeletonUrl,
          headers: {'x-access-token': token},
          body: json.encode(request));
    }
  }

  @override
  void sendMVPSkeleton(SendSkeletonRequest request) async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (_stompClient != null && (_stompClient?.isActive ?? false)) {
      _stompClient?.send(
          destination: AppUrl.socketMVPSkeletonUrl,
          headers: {'x-access-token': token},
          body: json.encode(request));
    }
  }

  @override
  void exitStage() async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (_stompClient != null && (_stompClient?.isActive ?? false)) {
      _stompClient?.send(
          destination: AppUrl.socketExitUrl,
          headers: {'x-access-token': token});
      _stompClient?.deactivate();
      _stompClient = null;
    }
  }

  void _setStageType(BaseSocketResponse response, StompFrame frame) {
    switch (response.type) {
      case SocketType.USER_COUNT:
        var socketResponse = BaseSocketResponse<UserCountResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            UserCountResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));

        setUserCount(socketResponse.data!.userCount);
        break;
      case SocketType.TALK_MESSAGE:
        var socketResponse = BaseSocketResponse<TalkMessageResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            TalkMessageResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));

        var talk = StageTalkListItem(
            content: socketResponse.data!.content,
            sender: socketResponse.data!.sender);

        setTalk(talk);
        // setIsTalk(true);
        break;
      case SocketType.TALK_REACTION:
        setIsReaction(true);
        break;
      case SocketType.CATCH_START:
        var socketResponse = BaseSocketResponse<CatchStartResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            CatchStartResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));
        _catchMusicData = socketResponse.data?.music;
        _socketType = response.type;
        setStageView(_socketType);
        break;
      case SocketType.CATCH_END:
        var socketResponse = BaseSocketResponse<CatchEndResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            CatchEndResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));
        _players.clear();
        _players.addAll(socketResponse.data?.players ?? []);
        break;
      case SocketType.CATCH_END_RESTART:
        setIsReCatch(true);
        break;
      case SocketType.PLAY_SKELETON:
        var socketResponse = BaseSocketResponse<SendSkeletonResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            SendSkeletonResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));
        Map<PoseLandmarkType, PoseLandmark> temp = {};
        socketResponse.data?.skeleton.forEach((key, value) {
          temp[PoseLandmarkType.values[int.parse(key)]] = PoseLandmark(
              type: PoseLandmarkType.values[value.type],
              x: value.x,
              y: value.y,
              z: value.z,
              likelihood: value.likelihood);
        });

        switch (socketResponse.data?.playerNum) {
          case 0:
            player0 = temp;
            break;
          case 1:
            player1 = temp;
            break;
          case 2:
            player2 = temp;
            break;
        }
        setIsPlaySkeletonChange(true);
        break;
      case SocketType.PLAY_END:
        player0 = null;
        player1 = null;
        player2 = null;
        break;
      case SocketType.MVP_START:
        var socketResponse = BaseSocketResponse<StageMVPResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            StageMVPResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));
        _mvp = _players.firstWhere((element) =>
            element.playerNum == socketResponse.data?.mvpPlayerNum);
        _playerInfos = socketResponse.data?.playerInfos ?? [];
        _socketType = response.type;
        setStageView(_socketType);
        break;
      case SocketType.MVP_SKELETON:
        var socketResponse = BaseSocketResponse<SendSkeletonResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            SendSkeletonResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));
        Map<PoseLandmarkType, PoseLandmark> temp = {};
        socketResponse.data?.skeleton.forEach((key, value) {
          temp[PoseLandmarkType.values[int.parse(key)]] = PoseLandmark(
              type: PoseLandmarkType.values[value.type],
              x: value.x,
              y: value.y,
              z: value.z,
              likelihood: value.likelihood);
        });
        mvpSkeleton = temp;
        setIsMVPSkeletonChange(true);
        break;

      default:
        _socketType = response.type;
        setStageView(_socketType);
    }
  }

  setStageView(SocketType stageType) {
    _navigatorKey.currentState?.pop();
    _navigatorKey.currentState?.pushNamed(socketTypeList[stageType.index]);
  }

  MaterialPageRoute onGenerateRoute(RouteSettings setting) {
    switch (stageType) {
      case SocketType.STAGE_ROUTINE_STOP:
      case SocketType.WAIT:
        return MaterialPageRoute<dynamic>(
            builder: (context) => const PoPoWaitView());
      case SocketType.CATCH:
      case SocketType.CATCH_START:
        return MaterialPageRoute<dynamic>(
            builder: (context) => const PoPoCatchView());
      case SocketType.PLAY:
      case SocketType.PLAY_START:
        return MaterialPageRoute<dynamic>(
            builder: (context) => PoPoPlayView(
                  isResultState: _socketType == SocketType.MVP_START,
                  players: _players,
                  userId: _userId,
                ));

      case SocketType.MVP:
      case SocketType.MVP_START:
        return (_mvp != null)
            ? MaterialPageRoute<dynamic>(
                builder: (context) => PoPoResultView(
                    isResultState: _socketType == SocketType.MVP_START,
                    mvp: _mvp,
                    userId: _userId!))
            : MaterialPageRoute<dynamic>(
                builder: (context) => PoPoResultView(
                    isResultState: _socketType == SocketType.MVP_START,
                    userId: _userId!));
      default:
        return MaterialPageRoute<dynamic>(
            builder: (context) => const PoPoWaitView());
    }
  }
}
