import 'package:flutter/material.dart';
import 'package:pocket_pose/data/remote/repository/like_repository.dart';

class LikeProvider extends ChangeNotifier {
  bool? _isPostSuccess;
  bool? _isDeleteSuccess;

  bool? get isPostSuccess => _isPostSuccess;
  bool? get isDeleteSuccess => _isDeleteSuccess;

  Future<void> postLike(String videoId) async {
    try {
      _isPostSuccess = await LikeRepository().postLike(videoId);

      notifyListeners();
    } catch (e) {
      debugPrint('moon error! LikeRepository postLike: $e');
    }
  }

  Future<void> deleteLike(String videoId) async {
    try {
      _isDeleteSuccess = await LikeRepository().deleteLike(videoId);

      notifyListeners();
    } catch (e) {
      debugPrint('moon error! LikeRepository deleteLike: $e');
    }
  }
}
