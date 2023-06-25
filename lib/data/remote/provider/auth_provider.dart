import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/data/entity/response/signin_signup_response.dart';
import 'package:pocket_pose/data/remote/repository/signin_signup_repository.dart';

const _storageKey = 'kakaoAccessToken';
const _refreshTokenKey = 'kakaoRefreshToken';

class AuthProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _accessToken;
  String? _refreshToken;
  SignInSignUpResponse? _response;

  String? get accessToken => _accessToken;
  SignInSignUpResponse? get response => _response;

  Future<bool> checkAccessToken() async {
    _accessToken = await storage.read(key: _storageKey);
    _refreshToken = await storage.read(key: _refreshTokenKey);

    notifyListeners();

    if (_accessToken != null && _refreshToken != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> storeAccessToken(String accessToken, String refreshToken) async {
    await storage.write(key: _storageKey, value: accessToken);
    await storage.write(key: _refreshTokenKey, value: refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    notifyListeners();
  }

  Future<void> removeAccessToken() async {
    await storage.delete(key: _storageKey);
    await storage.delete(key: _refreshTokenKey);
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void kakaoSignIn() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      debugPrint('카카오톡 로그인 성공! accessToken: ${token.accessToken}');

      _login(token.accessToken);
    } catch (error) {
      debugPrint('카카오톡으로 로그인 실패: $error');
    }
  }

  void kakaoSignOut() async {
    debugPrint('카카오톡 로그아웃');
    removeAccessToken();
  }

  Future<void> _login(String kakaoAccessToken) async {
    try {
      final repositoryResponse =
          await SignInSignUpRepository().login(kakaoAccessToken);
      _response = repositoryResponse;

      storeAccessToken(
          repositoryResponse.accessToken, repositoryResponse.refreshToken);

      notifyListeners();
    } catch (e) {
      debugPrint('Error logging in: $e');
    }
  }
}
