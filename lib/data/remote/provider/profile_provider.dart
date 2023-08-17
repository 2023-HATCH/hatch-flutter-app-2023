import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/remote/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileResponse? _profileResponse;
  bool? _isGetSuccess;

  ProfileResponse? get response => _profileResponse;
  bool? get isPostSuccess => _isGetSuccess;

  Future<bool> getUserProfile(String userId) async {
    try {
      final repositoryResponse =
          await ProfileRepository().getUserProfile(userId);
      _profileResponse = repositoryResponse;

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('ProfileProvider getUserProfile 에러: $e');
      return false;
    }
  }
}
