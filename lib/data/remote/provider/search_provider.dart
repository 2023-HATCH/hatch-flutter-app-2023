// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/remote/repository/search_repository.dart';
import 'package:pocket_pose/domain/entity/search_user_data.dart';

import '../../entity/request/videos_request.dart';
import '../../entity/response/videos_response.dart';

class SearchProvider extends ChangeNotifier {
  List<String>? _tagsResponse;
  VideosResponse? _tagVideosResponse;
  List<SearchUserData>? _usersResponse;
  VideosResponse? _randomVideosResponse;

  bool? _isGetTagsSuccess;
  bool? _isGetTagVideosSuccess;
  bool? _isGetUsersSuccess;
  bool? _isGetRandomVideoSuccess;
  bool _isVideoLoadingDone = false;

  List<String>? get tagResponse => _tagsResponse;
  VideosResponse? get tagVideosResponse => _tagVideosResponse;
  List<SearchUserData>? get usersResponse => _usersResponse;
  VideosResponse? get randomVideosResponse => _randomVideosResponse;

  bool? get isGetSuccess => _isGetTagsSuccess;
  bool? get isGetTagVideosSuccess => _isGetTagVideosSuccess;
  bool? get isGetUsersSuccess => _isGetUsersSuccess;
  bool? get isGetRandomVideoSuccess => _isGetRandomVideoSuccess;
  bool get isVideoLoadingDone => _isVideoLoadingDone;

  set randomVideosResponse(VideosResponse? value) {
    _randomVideosResponse = value;
  }

  set isGetRandomVideoSuccess(bool? value) {
    _isGetRandomVideoSuccess = value;
  }

  set tagVideosResponse(VideosResponse? value) {
    _tagVideosResponse = value;
  }

  set isGetTagVideosSuccess(bool? value) {
    _isGetTagVideosSuccess = value;
  }

  set isVideoLoadingDone(bool value) {
    _isVideoLoadingDone = value;
  }

  Future<bool> getTags() async {
    try {
      final repositoryResponse = await SearchRepository().getTags();
      _tagsResponse = repositoryResponse;

      _isGetTagsSuccess = true;
    } catch (e) {
      debugPrint('moon error! SearchRepository getTags: $e');
    }
    return _isGetTagsSuccess ?? false;
  }

  Future<bool> getTagSearch(
      String tag, VideosRequest searchVideosRequest) async {
    try {
      final repositoryResponse =
          await SearchRepository().getTagSearch(tag, searchVideosRequest);
      _tagVideosResponse = repositoryResponse;

      _isGetTagVideosSuccess = true;
    } catch (e) {
      debugPrint('moon error! SearchRepository getTagSearch: $e');
    }
    return _isGetTagVideosSuccess ?? false;
  }

  Future<bool> getUserSearch(String key) async {
    try {
      final repositoryResponse = await SearchRepository().getUserSearch(key);
      _usersResponse = repositoryResponse;

      _isGetUsersSuccess = true;
    } catch (e) {
      debugPrint('moon error! SearchRepository getUserSearch: $e');
    }
    return _isGetUsersSuccess ?? false;
  }

  Future<bool> getRandomVideos(VideosRequest videosRequest) async {
    try {
      final repositoryResponse =
          await SearchRepository().getRandomVideos(videosRequest);
      _randomVideosResponse = repositoryResponse;

      _isGetRandomVideoSuccess = true;
    } catch (e) {
      debugPrint('moon error! SearchRepository getRandomVideos: $e');
    }
    return _isGetRandomVideoSuccess ?? false;
  }
}
