// ignore_for_file: use_build_context_synchronously
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/data/entity/response/kakao_login_response.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/repository/kakao_login_repository.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/main.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';
import 'package:pocket_pose/ui/widget/login_modal_content_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const _storage = FlutterSecureStorage();
const _accessTokenKey = 'kakaoAccessToken';
const _refreshTokenKey = 'kakaoRefreshToken';
const _userUserIdKey = 'userUserId';
const _userNicknameKey = 'userNickname';
const _userProfileImgKey = 'userProfileImg';
const _userEmailKey = 'userEmail';
const _fcmTokenKey = 'fcmToken';

class KaKaoLoginProvider extends ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  KaKaoLoginResponse? _response;

  String get accessTokenKey => _accessTokenKey;
  String get refreshTokenKey => _refreshTokenKey;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  KaKaoLoginResponse? get response => _response;

  late BuildContext mainContext;
  bool isInstalled = false;

  // 카카오 로그인
  Future<bool> signIn() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      debugPrint('카카오톡 로그인 성공! accessToken: ${token.accessToken}');

      _login(token.accessToken).then((value) {
        Fluttertoast.showToast(
          msg: '성공적으로 로그인 되었습니다.',
        );

        final multiVideoPlayProvider =
            Provider.of<MultiVideoPlayProvider>(mainContext, listen: false);

        multiVideoPlayProvider.resetVideoPlayer(0);

        MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      debugPrint('moon error! KaKaoLoginProvider signIn: $e');
    }
    return isInstalled;
  }

  // 카카오 로그아웃
  void signOut() async {
    final multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(mainContext, listen: false);

    multiVideoPlayProvider.resetVideoPlayer(0);

    if (await KaKaoLoginRepository().logout()) {
      removeAccessToken();
      removeFCMToken();

      Fluttertoast.showToast(
        msg: '성공적으로 로그아웃 되었습니다.',
      );
    } else {
      Fluttertoast.showToast(msg: '로그아웃 실패했습니다. 다시 시도 하세요.');
    }

    notifyListeners();
  }

  // 카카오 서버 로그인
  Future<void> _login(String kakaoAccessToken) async {
    try {
      var fcmToken = await FirebaseMessaging.instance
          .getToken(vapidKey: dotenv.env['vapidKey']);

      if (fcmToken == null) {
        debugPrint('FCM: 토큰 얻기 실패!');
        Fluttertoast.showToast(
          msg: '로그인 실패했습니다. 다시 시도 하세요.',
        );
      } else {
        debugPrint('FCM: 토큰 얻기 성공!');
        final repositoryResponse =
            await KaKaoLoginRepository().login(kakaoAccessToken, fcmToken);
        _response = repositoryResponse;

        storeAccessToken(
            repositoryResponse.accessToken, repositoryResponse.refreshToken);
        storeUser(repositoryResponse.user);
        storeFCMToken(fcmToken);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('moon error! KaKaoLoginProvider login: $e');
    }
  }

  Future<void> storeUser(UserData user) async {
    await _storage.write(key: _userUserIdKey, value: user.userId);
    await _storage.write(key: _userNicknameKey, value: user.nickname);
    await _storage.write(key: _userProfileImgKey, value: user.profileImg);
    await _storage.write(key: _userEmailKey, value: user.email);

    notifyListeners();
  }

  Future<UserData> getUser() async {
    final userId = await _storage.read(key: _userUserIdKey);
    final nickname = await _storage.read(key: _userNicknameKey);
    final profileImg = await _storage.read(key: _userProfileImgKey);
    final email = await _storage.read(key: _userEmailKey);

    return UserData(
        userId: userId ?? '',
        nickname: nickname ?? '',
        profileImg: profileImg ?? '',
        email: email ?? '');
  }

  // FCM 토큰 관리
  Future<void> storeFCMToken(String fcmToken) async {
    await _storage.write(key: _fcmTokenKey, value: fcmToken);

    debugPrint('FCM 토큰 저장 성공!: ${await _storage.read(key: _fcmTokenKey)}');
    notifyListeners();
  }

  Future<String> getFCMToken() async {
    final fcmToken = await _storage.read(key: _fcmTokenKey);

    return fcmToken ?? '';
  }

  Future<void> removeFCMToken() async {
    await _storage.delete(key: _fcmTokenKey);

    debugPrint('FCM 토큰 삭제 성공!: ${await _storage.read(key: _fcmTokenKey)}');
    notifyListeners();
  }

  // 로그인 Token 관리
  Future<bool> checkAccessToken() async {
    if (_accessToken == null || _refreshToken == null) {
      _accessToken = await _storage.read(key: _accessTokenKey);
      _refreshToken = await _storage.read(key: _refreshTokenKey);
    }

    if (_accessToken != null && _refreshToken != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> storeAccessToken(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  // 토큰 분리
  String? extractToken(String? cookies, String tokenName) {
    if (cookies == null) return null;
    final pattern = '$tokenName=';
    final tokenStartIndex = cookies.indexOf(pattern);
    if (tokenStartIndex == -1) return null;
    final tokenEndIndex = cookies.indexOf(';', tokenStartIndex);
    if (tokenEndIndex == -1) {
      return cookies.substring(tokenStartIndex + pattern.length);
    }
    return cookies.substring(tokenStartIndex + pattern.length, tokenEndIndex);
  }

  // 토큰 갱신
  void updateToken(Map<String, String> headers) async {
    final cookies = headers['set-cookie'];

    if (cookies != null) {
      final newAaccessToken = extractToken(cookies, 'x-access-token');
      final newRrefreshToken = extractToken(cookies, 'x-refresh-token');

      if (newAaccessToken != null && newRrefreshToken != null) {
        storeAccessToken(newAaccessToken, newRrefreshToken);
        debugPrint('토큰 갱신 성공!');
      }
    }
  }

  // 토큰 삭제
  Future<void> removeAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  // 로그인 바텀 시트
  void showLoginBottomSheet() {
    showModalBottomSheet(
      context: mainContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return const LoginModalContent();
      },
    );
  }
}
