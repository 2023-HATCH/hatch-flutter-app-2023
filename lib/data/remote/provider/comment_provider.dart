import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/comment_list_response.dart';
import 'package:pocket_pose/data/remote/repository/comment_repository.dart';

class CommentProvider extends ChangeNotifier {
  CommentListResponse? _response;

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
}
