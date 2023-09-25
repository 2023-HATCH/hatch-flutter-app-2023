import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/response/kakao_login_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

class KaKaoLoginRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<KaKaoLoginResponse> login(
      String kakaoAccessToken, String fcmToken) async {
    final url = Uri.parse(AppUrl.signInSignUpUrl);
    final headers = {
      'Content-Type': 'application/json;charset=UTF-8',
    };
    final body = jsonEncode({
      'kakaoAccessToken': kakaoAccessToken,
      'fcmNotificationToken': fcmToken
    });

    final response = await http.post(url, headers: headers, body: body);
    debugPrint("response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("카카오 로그인 성공!");

      final user = UserData(
        userId: json['data']['userId'],
        nickname: json['data']['nickname'],
        email: json['data']['email'],
        profileImg: json['data']['profileImg'],
      );

      final cookies = response.headers['set-cookie'];
      final accessToken = loginProvider.extractToken(cookies, 'x-access-token');
      final refreshToken =
          loginProvider.extractToken(cookies, 'x-refresh-token');

      return KaKaoLoginResponse(
        accessToken: accessToken!,
        refreshToken: refreshToken!,
        user: user,
      );
    } else {
      debugPrint("카카오 로그인 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repositorykakao_login_repository.dart');
    }
  }

  Future<bool> logout() async {
    final url = Uri.parse(AppUrl.logOutUrl);

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("카카오 로그아웃 성공! json: $json");

      loginProvider.updateToken(response.headers);

      return true;
    } else {
      debugPrint("카카오 로그아웃 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repositorykakao_login_repository.dart');
    }
  }
}
