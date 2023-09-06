import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/response/share_response.dart';
import 'package:pocket_pose/data/remote/repository/share_repository_impl.dart';
import 'package:pocket_pose/domain/provider/share_provider.dart';

class ShareProviderImpl extends ChangeNotifier implements ShareProvider {
  final ShareRepositoryImpl _shareRepository = ShareRepositoryImpl();

  @override
  Future<BaseResponse<ShareResponse>> getVideoDetail(String videoId) async {
    return await _shareRepository.getVideoDetail(videoId);
  }
}
