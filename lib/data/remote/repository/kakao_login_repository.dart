import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/response/kakao_login_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

class KaKaoLoginRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<KaKaoLoginResponse> login(String kakaoAccessToken) async {
    final url = Uri.parse(AppUrl.signInSignUpUrl);
    final headers = {
      'Content-Type': 'application/json;charset=UTF-8',
    };
    final body = jsonEncode({
      'kakaoAccessToken': kakaoAccessToken,
    });

    final response = await http.post(url, headers: headers, body: body);
    debugPrint("response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("json: $json");

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
      throw Exception('Login failed');
    }
  }
}
