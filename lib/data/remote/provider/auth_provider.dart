import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pocket_pose/data/entity/response/signin_signup_response.dart';
import 'package:pocket_pose/data/remote/repository/signin_signup_repository.dart';

const _storageKey = 'kakaoAccessToken';

class AuthProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _accessToken;

  String? get accessToken => _accessToken;
  // ignore: avoid_init_to_null
  SignInSignUpResponse? response = null;

  Future<void> checkAccessToken() async {
    final accessToken = await storage.read(key: _storageKey);
    _accessToken = accessToken;

    notifyListeners();
  }

  Future<void> storeAccessToken(String accessToken) async {
    await storage.write(key: _storageKey, value: accessToken);
    _accessToken = accessToken;
    notifyListeners();
  }

  Future<void> removeAccessToken() async {
    await storage.delete(key: _storageKey);
    _accessToken = null;
    notifyListeners();
  }

  void kakaoSignIn() async {
    try {
      //카카오톡 설치 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          //카카오톡이 설치되어 있다면 카카오톡을 실행하여 로그인
          ? await UserApi.instance.loginWithKakaoTalk()
          //카카오톡이 설치되어 있지 않다면 웹으로 로그인
          : await UserApi.instance.loginWithKakaoAccount();

      // 로그인 성공
      storeAccessToken(token.accessToken);

      //로그인을 성공했다면 OAuthToken 으로 accessToken 값을 받아올 수 있음
      debugPrint('카카오톡 로그인 성공! accessToken:${token.accessToken}');

      // 로그인을 성공했다면 서버 api를 통해 kakao token 전송
      _login(token.accessToken);

      //유저 정보 확인
      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      //토큰 값으로 유저정보를 확인하는 요청을 보내면 이름과 이메일 정보를 얻을 수 있음
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      debugPrint(profileInfo.toString());
    } catch (error) {
      debugPrint('카카오톡으로 로그인 실패 $error');
    }
  }

  void kakaoSignOut() async {
    //로그아웃
    debugPrint('카카오톡 로그아웃');
    removeAccessToken();
  }

  Future<void> _login(String kakaoAccessToken) async {
    try {
      final repositoryResponse =
          await SignInSignUpRepository().login(kakaoAccessToken);
      response = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint(
          "lib/data/remote/provider/signin_signup_provider.dart error catch: ${e.toString()}");
    }
  }
}
