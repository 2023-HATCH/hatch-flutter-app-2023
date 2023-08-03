import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/data/entity/response/comment_list_response.dart';
import 'package:pocket_pose/domain/entity/comment_data.dart';

const _storage = FlutterSecureStorage();
const _accessTokenKey = 'kakaoAccessToken';
const _refreshTokenKey = 'kakaoRefreshToken';

class CommentRepository {
  Future<CommentListResponse> getComments(String videoId) async {
    final url = Uri.parse('${AppUrl.commentUrl}/$videoId');

    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("댓글 목록 조회 성공! json: $json");

      final List<dynamic> commentListJson = json['data']['commentList'];
      final List<CommentData> commentList = commentListJson
          .map((commentJson) => CommentData.fromJson(commentJson))
          .toList();

      return CommentListResponse(
        commentList: commentList,
      );
    } else {
      throw Exception('댓글 목록 조회 실패');
    }
  }
}
