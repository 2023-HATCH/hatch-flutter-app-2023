import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/domain/repository/share_repository.dart';

class ShareRepositoryImpl implements ShareRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  @override
  Future<VideoData> getVideoDetail(String videoId) async {
    final url = Uri.parse('${AppUrl.videoUrl}/$videoId');

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("공유 비디오 조회 성공! json: $json");

      final dynamic videoJson = json['data'];
      final VideoData videoData = VideoData.fromJson(videoJson);

      loginProvider.updateToken(response.headers);

      return videoData;
    } else {
      throw Exception('공유 비디오 조회 실패');
    }
  }
}
