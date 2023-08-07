import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/request/home_videos_request.dart';
import 'package:pocket_pose/data/entity/response/home_videos_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';

class HomeRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<HomeVideosResponse> getVideos(
      HomeVideosRequest homeVideosRequest) async {
    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final url = Uri.parse(AppUrl.homeVideosUrl).replace(queryParameters: {
      'page': homeVideosRequest.page.toString(),
      'size': homeVideosRequest.size.toString(),
    });

    final headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("홈 비디오 목록 조회 성공! json: $json");

      final List<dynamic> videoListJson = json['data']['videoList'];
      final List<VideoData> videoList = videoListJson
          .map((videoJson) => VideoData.fromJson(videoJson))
          .toList();

      final bool isLast = json['data']['isLast'];

      return HomeVideosResponse(
        videoList: videoList,
        isLast: isLast,
      );
    } else {
      throw Exception('홈 비디오 목록 조회 실패');
    }
  }
}
