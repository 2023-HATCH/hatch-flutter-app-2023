import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';

class LikeRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<bool> postLike(String videoId) async {
    final url = Uri.parse('${AppUrl.likeUrl}/$videoId');

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.post(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("좋아요 등록 성공!");

      loginProvider.updateToken(response.headers);

      return true;
    } else {
      debugPrint("좋아요 등록 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/like_repository.dart');
    }
  }

  Future<bool> deleteLike(String videoId) async {
    final url = Uri.parse('${AppUrl.likeUrl}/$videoId');

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.delete(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("좋아요 삭제 성공!");

      loginProvider.updateToken(response.headers);

      return true;
    } else {
      debugPrint("좋아요 삭제 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/like_repository.dart');
    }
  }
}
