import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/domain/provider/popo_skeleton_provider.dart';

class PoPoSkeletonProviderImpl implements PoPoSkeletonProvider {
  @override
  Future postSkeletonList(List<List<double>> seq) async {
    var dio = Dio();
    try {
      dio.options.contentType = "application/json";
      var response =
          await dio.post(AppUrl.skeletonAccuracyUrl, data: {"seq": seq});
      return response;
    } catch (e) {
      debugPrint("mmm PoPoSkeletonProviderImpl catch: ${e.toString()}");
    }
    return null;
  }
}
