import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/search_user_data.dart';
import '../../../domain/entity/video_data.dart';
import '../../entity/request/videos_request.dart';

class SearchRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<List<String>> getTags() async {
    final url = Uri.parse(AppUrl.searchTagsUrl);

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("태그 목록 조회 성공! json: $json");

      final List<dynamic> tagListJson = json['data']['tagList'];
      final List<String> tagList = tagListJson.cast<String>();

      return tagList;
    } else {
      throw Exception('태그 목록 조회 실패');
    }
  }

  Future<VideosResponse> getTagSearch(
      String tag, VideosRequest searchVideosRequest) async {
    final url = Uri.parse(AppUrl.searchTagVideoUrl).replace(queryParameters: {
      'tag': tag,
      'page': searchVideosRequest.page.toString(),
      'size': searchVideosRequest.size.toString(),
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

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("검색 태그 검색 비디오 목록 조회 성공! json: $json");

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
      throw Exception('검색 태그 검색 비디오 목록 조회 실패');
    }
  }

  Future<List<SearchUserData>> getUserSearch(String key) async {
    final url =
        Uri.parse(AppUrl.searchUserUrl).replace(queryParameters: {'key': key});

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("검색 사용자 검색 성공! json: $json");

      final List<dynamic> searchUserDataJson = json['data']['userList'];
      final List<SearchUserData> searchUserDataList = searchUserDataJson
          .map((userJson) => SearchUserData.fromJson(userJson))
          .toList();

      return searchUserDataList;
    } else {
      throw Exception('검색 사용자 검색 실패');
    }
  }

  Future<VideosResponse> getRandomVideos(VideosRequest videosRequest) async {
    final url =
        Uri.parse('${AppUrl.videoUrl}/random').replace(queryParameters: {
      'page': videosRequest.page.toString(),
      'size': videosRequest.size.toString(),
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

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("검색 랜덤 비디오 목록 조회 성공! json: $json");

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
      throw Exception('검색 랜덤 비디오 목록 조회 실패');
    }
  }
}
