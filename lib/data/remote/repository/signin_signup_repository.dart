import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/response/signin_signup_response.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

class SignInSignUpRepository {
  String? _extractToken(String? cookies, String tokenName) {
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

  Future<SignInSignUpResponse> login(String kakaoAccessToken) async {
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
        uuid: json['data']['uuid'],
        nickname: json['data']['nickname'],
        email: json['data']['email'],
      );

      final cookies = response.headers['set-cookie'];
      final accessToken = _extractToken(cookies, 'x-access-token');
      final refreshToken = _extractToken(cookies, 'x-refresh-token');

      return SignInSignUpResponse(
        accessToken: accessToken!,
        refreshToken: refreshToken!,
        user: user,
      );
    } else {
      throw Exception('Login failed');
    }
  }
}
