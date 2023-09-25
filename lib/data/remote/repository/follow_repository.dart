import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/response/follow_list_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/follow_data.dart';

class FollowRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<FollowListResponse> getFollows(String userId) async {
    final url = Uri.parse('${AppUrl.followUrl}/$userId');

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("팔로우 목록 조회 성공!");

      final List<dynamic> followerListJson = json['data']['followerList'];
      final List<FollowData> followerList = followerListJson
          .map((followerListJson) => FollowData.fromJson(followerListJson))
          .toList();

      final List<dynamic> followingListJson = json['data']['followingList'];
      final List<FollowData> followingList = followingListJson
          .map((followingListJson) => FollowData.fromJson(followingListJson))
          .toList();

      return FollowListResponse(
        followerList: followerList,
        followingList: followingList,
      );
    } else {
      debugPrint("팔로우 목록 조회 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/follow_repository.dart');
    }
  }

  Future<bool> postFollow(String userId) async {
    final url = Uri.parse('${AppUrl.followUrl}/$userId');

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
      debugPrint("팔로우 등록 성공!");

      loginProvider.updateToken(response.headers);

      return true;
    } else {
      debugPrint("팔로우 등록 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/follow_repository.dart');
    }
  }

  Future<bool> deleteFollow(String userId) async {
    final url = Uri.parse('${AppUrl.followUrl}/$userId');

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
      debugPrint("팔로우 삭제 성공!");

      loginProvider.updateToken(response.headers);

      return true;
    } else {
      debugPrint("팔로우 삭제 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/follow_repository.dart');
    }
  }
}
