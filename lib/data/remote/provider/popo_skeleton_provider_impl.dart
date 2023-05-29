import 'dart:convert';
import 'dart:async';

import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/domain/provider/popo_skeleton_provider.dart';
import 'package:http/http.dart' as http;

class PoPoSkeletonProviderImpl implements PoPoSkeletonProvider {
  @override
  Future<String> postSkeletonList(List<List<int>> seq) async {
    final response = await http.post(
      Uri.parse(AppUrl.skeletonAccuracyUrl),
      body: json.encode(seq),
    );

    final dynamic responseJson = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      return "정확도 측정에 실패했습니다.";
    }
  }
}
