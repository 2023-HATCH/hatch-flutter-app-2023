// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/profile_edit_request.dart';
import 'package:pocket_pose/data/entity/request/profile_videos_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
import 'package:pocket_pose/data/remote/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileResponse? _profileResponse;
  VideosResponse? _uploadVideosResponse;
  VideosResponse? _likeVideosResponse;
  bool? _isGetSuccess;
  bool? _isPatchSuccess;

  ProfileResponse? get profileResponse => _profileResponse;
  VideosResponse? get uploadVideosResponse => _uploadVideosResponse;
  VideosResponse? get likeVideosResponse => _likeVideosResponse;
  bool? get isPostSuccess => _isGetSuccess;
  bool? get isPatchSuccess => _isPatchSuccess;

  bool _isGetProfilDone = false;
  bool _isVideoLoadingDone = false;

  bool get isGetProfilDone => _isGetProfilDone;
  bool get isVideoLoadingDone => _isVideoLoadingDone;

  set profileResponse(ProfileResponse? value) {
    _profileResponse = value;
  }

  set isGetProfilDone(bool value) {
    _isGetProfilDone = value;
  }

  set isVideoLoadingDone(bool value) {
    _isVideoLoadingDone = value;
  }

  set uploadVideosResponse(VideosResponse? value) {
    _uploadVideosResponse = value;
  }

  set likeVideosResponse(VideosResponse? value) {
    _likeVideosResponse = value;
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

      // controller랑 future 만들기

      notifyListeners();
    } catch (e) {
      debugPrint('ProfileProvider getUploadVideos 에러: $e');
    }
  }

  Future<void> getLikeVideos(ProfileVideosRequest profileVideosRequest) async {
    try {
      final repositoryResponse =
          await ProfileRepository().getLikeVideos(profileVideosRequest);
      _likeVideosResponse = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint('ProfileProvider getLikeVideos 에러: $e');
    }
  }
}
