import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/profile_edit_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/remote/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileResponse? _profileResponse;
  bool? _isGetSuccess;
  bool? _isPatchSuccess;

  ProfileResponse? get response => _profileResponse;
  bool? get isPostSuccess => _isGetSuccess;
  bool? get _sPatchSuccess => _isPatchSuccess;

  bool _isGetProfilDone = false;

  bool get isGetProfilDone => _isGetProfilDone;

  // Setter for isGetProfilDone
  set isGetProfilDone(bool value) {
    _isGetProfilDone = value;
  }

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

  Future<bool> patchProfile(ProfileEditRequest profileEditRequest) async {
    try {
      _isPatchSuccess =
          await ProfileRepository().patchProfile(profileEditRequest);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('ProfileProvider getUserProfile 에러: $e');
      return false;
    }
  }
}
