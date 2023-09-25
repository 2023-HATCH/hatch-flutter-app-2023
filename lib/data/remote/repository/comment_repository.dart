import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/response/comment_list_response.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/comment_data.dart';

class CommentRepository {
  KaKaoLoginProvider loginProvider = KaKaoLoginProvider();

  Future<CommentListResponse> getComments(String videoId) async {
    final url = Uri.parse('${AppUrl.commentUrl}/$videoId');

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("댓글 목록 조회 성공!");

      final List<dynamic> commentListJson = json['data']['commentList'];
      final List<CommentData> commentList = commentListJson
          .map((commentJson) => CommentData.fromJson(commentJson))
          .toList();

      return CommentListResponse(
        commentList: commentList,
      );
    } else {
      debugPrint("댓글 목록 조회 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/comment_repository.dart');
    }
  }

  Future<bool> postComment(String videoId, String content) async {
    final url = Uri.parse('${AppUrl.commentUrl}/$videoId');

    await loginProvider.checkAccessToken();

    final accessToken = loginProvider.accessToken;
    final refreshToken = loginProvider.refreshToken;

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      if (accessToken != null && refreshToken != null)
        "cookie": "x-access-token=$accessToken;x-refresh-token=$refreshToken"
    };

    final Map<String, dynamic> body = {
      'content': content,
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      debugPrint("댓글 등록 성공!");

      loginProvider.updateToken(response.headers);

      return true;
    } else {
      debugPrint("댓글 등록 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/comment_repository.dart');
    }
  }

  Future<bool> deleteComment(String commentId) async {
    final url = Uri.parse('${AppUrl.commentUrl}/$commentId');

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
      debugPrint("댓글 삭제 성공!");
      loginProvider.updateToken(response.headers);

      return true;
    } else {
      debugPrint("댓글 삭제 실패! json: $json");
      throw Exception(
          'moon error! lib/data/remote/repository/comment_repository.dart');
    }
  }
}
