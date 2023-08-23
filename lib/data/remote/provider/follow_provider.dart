import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/follow_list_response.dart';
import 'package:pocket_pose/data/remote/repository/follow_repository.dart';

class FollowProvider extends ChangeNotifier {
  FollowListResponse? _response;
  bool? _isGetSuccess;
  bool? _isPostSuccess;
  bool? _isDeleteSuccess;

  bool? get isGetSuccess => _isGetSuccess;
  bool? get isPostSuccess => _isPostSuccess;
  bool? get isDeleteSuccess => _isDeleteSuccess;

  FollowListResponse? get response => _response;

  Future<bool> getFollows(String userId) async {
    try {
      final repositoryResponse = await FollowRepository().getFollows(userId);
      _response = repositoryResponse;

      _isGetSuccess = true;
    } catch (e) {
      debugPrint('FollowRepository getFollows 에러: $e');
    }
    return _isGetSuccess ?? false;
  }

  Future<bool> postFollow(String userId) async {
    try {
      _isPostSuccess = await FollowRepository().postFollow(userId);

      notifyListeners();
    } catch (e) {
      debugPrint('FollowRepository postFollow 에러: $e');
    }
    return _isPostSuccess ?? false;
  }

  Future<bool> deleteFollow(String userId) async {
    try {
      _isDeleteSuccess = await FollowRepository().deleteFollow(userId);
    } catch (e) {
      debugPrint('FollowRepository deleteFollow 에러: $e');
    }

    return _isDeleteSuccess ?? false;
  }
}
