import 'package:flutter/material.dart';
import 'package:pocket_pose/data/remote/repository/like_repository.dart';

class LikeProvider extends ChangeNotifier {
  bool? _isSuccess;

  bool? get isSuccess => _isSuccess;

  Future<void> postLike(String videoId) async {
    try {
      _isSuccess = await LikeRepository().postLike(videoId);

      notifyListeners();
    } catch (e) {
      debugPrint('LikeRepository postLike 에러: $e');
    }
  }
}
