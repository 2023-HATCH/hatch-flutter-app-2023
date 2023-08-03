import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocket_pose/data/entity/response/kakao_login_response.dart';
import 'package:pocket_pose/data/remote/repository/kakao_login_repository.dart';
import 'package:pocket_pose/ui/widget/login_modal_content_widget.dart';

const _storage = FlutterSecureStorage();
const _accessTokenKey = 'kakaoAccessToken';
const _refreshTokenKey = 'kakaoRefreshToken';

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

  // 카카오 로그인, 로그아웃
  void signIn() async {
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

  void signOut() async {
    debugPrint('카카오톡 로그아웃');
    removeAccessToken();
  }

  Future<void> _login(String kakaoAccessToken) async {
    try {
      final repositoryResponse =
          await KaKaoLoginRepository().login(kakaoAccessToken);
      _response = repositoryResponse;

      storeAccessToken(
          repositoryResponse.accessToken, repositoryResponse.refreshToken);

      notifyListeners();
    } catch (e) {
      debugPrint('Error logging in: $e');
    }
  }

  // token 관리
  Future<bool> checkAccessToken() async {
    _accessToken = await _storage.read(key: _accessTokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);

    notifyListeners();

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

  Future<void> removeAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

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
