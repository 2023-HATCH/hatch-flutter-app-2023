import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/profile_edit_request.dart';
import 'package:pocket_pose/data/entity/request/profile_videos_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
import 'package:pocket_pose/data/remote/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileResponse? _profileResponse;
  VideosResponse? _uploadVideosResponse;
  bool? _isGetSuccess;
  bool? _isPatchSuccess;

  ProfileResponse? get profileResponse => _profileResponse;
  VideosResponse? get uploadVideosResponse => _uploadVideosResponse;
  bool? get isPostSuccess => _isGetSuccess;
  bool? get isPatchSuccess => _isPatchSuccess;

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

  Future<void> getUploadVideos(
      ProfileVideosRequest profileVideosRequest) async {
    try {
      final repositoryResponse =
          await ProfileRepository().getUploadVideos(profileVideosRequest);
      _uploadVideosResponse = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint('ProfileProvider getUploadVideos 에러: $e');
    }
  }

  Future<void> getLikeVideos(ProfileVideosRequest profileVideosRequest) async {
    try {
      final repositoryResponse =
          await ProfileRepository().getUploadVideos(profileVideosRequest);
      _uploadVideosResponse = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint('ProfileProvider getUploadVideos 에러: $e');
    }
  }
}
