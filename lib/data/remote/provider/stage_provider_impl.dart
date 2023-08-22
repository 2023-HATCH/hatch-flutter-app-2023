import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/stage_enter_request.dart';
import 'package:pocket_pose/data/entity/response/stage_enter_response.dart';
import 'package:pocket_pose/data/entity/response/stage_user_list_response.dart';
import 'package:pocket_pose/data/remote/repository/stage_repository_impl.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';
import 'package:pocket_pose/domain/provider/stage_provider.dart';

class StageProviderImpl extends ChangeNotifier implements StageProvider {
  final StageRepositoryImpl _stageRepository = StageRepositoryImpl();

  final List<StageTalkListItem> _talkList = [];
  final List<UserListItem> _userList = [];
  late double? _stageCurSecond;
  bool _isClicked = false;

  List<StageTalkListItem> get talkList => _talkList;
  List<UserListItem> get userList => _userList;
  double? get stageCurTime => _stageCurSecond;

  bool get isClicked => _isClicked;
  setIsClicked(bool value) => _isClicked = value;
  setStageCurSecondNULL() => _stageCurSecond = null;

  void toggleIsLeft() {
    if (isClicked) notifyListeners();
  }

  void addTalkList(List<StageTalkListItem> list) {
    _talkList.addAll(list);
    notifyListeners();
  }

  void addTalk(StageTalkListItem talk) {
    _talkList.insert(0, talk);
    notifyListeners();
  }

  @override
  Future<BaseResponse<StageUserListResponse>> getUserList() async {
    var response = await _stageRepository.getUserList();

    _userList.clear();
    _userList.addAll(response.data.list ?? []);

    notifyListeners();
    return response;
  }

  @override
  Future<BaseResponse<StageEnterResponse>> getStageEnter(
      StageEnterRequest request) async {
    var response = await _stageRepository.getStageEnter(request);
    _stageCurSecond = response.data.statusElapsedTime;

    addTalkList(response.data.talkMessageData.messages ?? []);

    notifyListeners();

    return response;
  }

  @override
  Future<void> getStageCatch() async {
    return await _stageRepository.getStageCatch();
  }
}
