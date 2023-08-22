import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/comment_list_response.dart';
import 'package:pocket_pose/data/remote/repository/comment_repository.dart';
import 'package:pocket_pose/data/remote/repository/follow_repository.dart';

class FollowProvider extends ChangeNotifier {
  CommentListResponse? _response;
  bool? _isPostSuccess;
  bool? _isDeleteSuccess;

  bool? get isPostSuccess => _isPostSuccess;
  bool? get isDeleteSuccess => _isDeleteSuccess;

  CommentListResponse? get response => _response;

  Future<void> getComments(String videoId) async {
    try {
      final repositoryResponse = await CommentRepository().getComments(videoId);
      _response = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint('CommentRepository getComments 에러: $e');
    }
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
