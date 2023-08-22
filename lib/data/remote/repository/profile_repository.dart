import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/request/profile_edit_request.dart';
import 'package:pocket_pose/data/entity/request/profile_videos_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/profile_data.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';

class ProfileRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<ProfileResponse> getUserProfile(String userId) async {
    final url = Uri.parse('${AppUrl.profileUrl}/$userId');

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
      debugPrint("프로필 정보 조회 성공! json: $json");

      loginProvider.updateToken(response.headers);

      final user = UserData(
        userId: json['data']['userId'],
        nickname: json['data']['nickname'],
        email: json['data']['email'],
        profileImg: json['data']['profileImg'],
      );

      final profile = ProfileData(
        isMe: json['data']['isMe'],
        introduce: json['data']['introduce'],
        instagramId: json['data']['instagramId'],
        twitterId: json['data']['twitterId'],
        followingCount: json['data']['followingCount'],
        followerCount: json['data']['followerCount'],
        isFollowing: json['data']['isFollowing'],
      );

      return ProfileResponse(
        user: user,
        profile: profile,
      );
    } else {
      throw Exception('프로필 정보 조회 실패');
    }
  }

  Future<bool> patchProfile(ProfileEditRequest profileEditRequest) async {
    final url = Uri.parse('${AppUrl.profileEditUrl}/');

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final body = jsonEncode({
      'introduce': profileEditRequest.introduce,
      'instagramId': profileEditRequest.instagramId,
      'twitterId': profileEditRequest.twitterId,
    });

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("프로필 수정 성공! json: $json");

      loginProvider.updateToken(response.headers);

      return true;
    } else {
      throw Exception('프로필 수정 실패');
    }
  }

  Future<VideosResponse> getUploadVideos(
      ProfileVideosRequest profileVideosRequest) async {
    final url =
        Uri.parse('${AppUrl.profileVideoUrl}/${profileVideosRequest.userId}')
            .replace(queryParameters: {
      'page': profileVideosRequest.page.toString(),
      'size': profileVideosRequest.size.toString(),
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
      debugPrint("프로필 업로드한 비디오 목록 조회 성공! json: $json");

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
      throw Exception('프로필 업로드한 비디오 목록 조회 실패');
    }
  }

  Future<VideosResponse> getLikeVideos(
      ProfileVideosRequest profileVideosRequest) async {
    final url = Uri.parse(
            '${AppUrl.profileLikeVideoUrl}/${profileVideosRequest.userId}')
        .replace(queryParameters: {
      'page': profileVideosRequest.page.toString(),
      'size': profileVideosRequest.size.toString(),
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
      debugPrint("프로필 좋아요한 비디오 목록 조회 성공! json: $json");

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
      throw Exception('프로필 좋아요한 비디오 목록 조회 실패');
    }
  }
}
