import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/stage_talk_message_request.dart';
import 'package:pocket_pose/data/entity/response/stage_talk_message_response.dart';
import 'package:pocket_pose/data/remote/repository/stage_talk_repository_impl.dart';
import 'package:pocket_pose/domain/provider/stage_talk_provider.dart';

class StageTalkProviderImpl extends ChangeNotifier
    implements StageTalkProvider {
  final StageTalkRepositoryImpl _stageTalkRepository =
      StageTalkRepositoryImpl();
  @override
  Future<BaseResponse<StageTalkMessageResponse>> getTalkMessages(
      StageTalkMessageRequest request) async {
    return await _stageTalkRepository.getTalkMessages(request);
  }
}
