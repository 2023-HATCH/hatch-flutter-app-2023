import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/comment_list_response.dart';
import 'package:pocket_pose/data/remote/repository/comment_repository.dart';

class CommentProvider extends ChangeNotifier {
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

  Future<void> postComment(String videoId, String content) async {
    try {
      _isPostSuccess = await CommentRepository().postComment(videoId, content);

      notifyListeners();
    } catch (e) {
      debugPrint('CommentRepository postComment 에러: $e');
    }
  }
}
