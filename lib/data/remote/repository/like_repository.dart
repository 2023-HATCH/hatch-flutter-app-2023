import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';

const _storage = FlutterSecureStorage();
const _accessTokenKey = 'kakaoAccessToken';
const _refreshTokenKey = 'kakaoRefreshToken';

class LikeRepository {
  Future<bool> postLike(String videoId) async {
    final url = Uri.parse('${AppUrl.likeUrl}/$videoId');

    debugPrint('좋아요 Uri videoId ${AppUrl.likeUrl}/$videoId');
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.post(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("좋아요 등록 성공! json: $json");
      return true;
    } else {
      debugPrint('좋아요 등록 실패 json $json');
      return false;
    }
  }

  Future<bool> deleteLike(String videoId) async {
    final url = Uri.parse('${AppUrl.likeUrl}/$videoId');

    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.delete(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("좋아요 삭제 성공! json: $json");
      return true;
    } else {
      debugPrint('좋아요 삭제 실패 json $json');
      return false;
    }
  }
}
