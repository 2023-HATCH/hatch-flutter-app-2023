import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';

class VideoRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<VideosResponse> getVideos(VideosRequest homeVideosRequest) async {
    final url = Uri.parse(AppUrl.videoUrl).replace(queryParameters: {
      'page': homeVideosRequest.page.toString(),
      'size': homeVideosRequest.size.toString(),
    });

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.get(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("홈 비디오 목록 조회 성공!");

      final List<dynamic> videoListJson = json['data']['videoList'];
      final List<VideoData> videoList = videoListJson
          .map((videoJson) => VideoData.fromJson(videoJson))
          .toList();

      final bool isLast = json['data']['isLast'];

      loginProvider.updateToken(response.headers);

      return VideosResponse(
        videoList: videoList,
        isLast: isLast,
      );
    } else {
      debugPrint("홈 비디오 목록 조회 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/video_repository.dart');
    }
  }

  Future<bool> deleteVideo(String videoId) async {
    final url = Uri.parse('${AppUrl.videoUrl}/$videoId');

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final response = await http.delete(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("비디오 삭제 성공!");
      return true;
    } else {
      debugPrint("비디오 삭제 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/video_repository.dart');
    }
  }

  Future<void> getView(String videoId) async {
    final url = Uri.parse('${AppUrl.videoUrl}/$videoId/view');

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final response = await http.get(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    loginProvider.updateToken(response.headers);

    if (response.statusCode == 200) {
      debugPrint("조회수 증가 성공!");
    } else {
      debugPrint("조회수 증가 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/video_repository.dart');
    }
  }
}
