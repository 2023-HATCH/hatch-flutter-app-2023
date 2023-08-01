import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/request/home_videos_request.dart';
import 'package:pocket_pose/data/entity/response/home_videos_response.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';

class HomeRepository {
  Future<HomeVideosResponse> getVideos(
      HomeVideosRequest homeVideosRequest) async {
    final url = Uri.parse(AppUrl.homeVideosUrl).replace(queryParameters: {
      'page': homeVideosRequest.page.toString(),
      'size': homeVideosRequest.size.toString(),
    });

    final headers = {
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("홈 비디오 조회 성공! json: $json");

      final List<dynamic> videoListJson = json['data']['videoList'];
      debugPrint("홈 비디오 조회 성공! videoListJson: $videoListJson");

      final List<VideoData> videoList = videoListJson
          .map((videoJson) => VideoData.fromJson(videoJson))
          .toList();

      debugPrint("홈 비디오 조회 성공! videoList: $videoList");

      final bool isLast = json['data']['isLast'];
      debugPrint("홈 비디오 조회 성공! isLast: $isLast");

      return HomeVideosResponse(
        videoList: videoList,
        isLast: isLast,
      );
    } else {
      throw Exception('Failed to fetch videos');
    }
  }
}
