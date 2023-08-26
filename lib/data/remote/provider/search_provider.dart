import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/follow_list_response.dart';
import 'package:pocket_pose/data/remote/repository/follow_repository.dart';
import 'package:pocket_pose/data/remote/repository/search_repository.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

import '../../entity/request/videos_request.dart';
import '../../entity/response/videos_response.dart';

class SearchProvider extends ChangeNotifier {
  List<String>? _tagsResponse;
  VideosResponse? _tagVideosResponse;
  List<UserData>? _usersResponse;

  bool? _isGetTagsSuccess;
  bool? _isGetTagVideosSuccess;
  bool? _isGetUsersSuccess;
  // bool? _isPostSuccess;
  // bool? _isDeleteSuccess;

  List<String>? get tagResponse => _tagsResponse;
  VideosResponse? get tagVideosResponse => _tagVideosResponse;
  List<UserData>? get usersResponse => _usersResponse;

  bool? get isGetSuccess => _isGetTagsSuccess;
  bool? get isGetTagVideosSuccess => _isGetTagVideosSuccess;
  bool? get isGetUsersSuccess => _isGetUsersSuccess;

  // bool? get isPostSuccess => _isPostSuccess;
  // bool? get isDeleteSuccess => _isDeleteSuccess;

  Future<bool> getTags() async {
    try {
      final repositoryResponse = await SearchRepository().getTags();
      _tagsResponse = repositoryResponse;

      _isGetTagsSuccess = true;
    } catch (e) {
      debugPrint('SearchRepository getTags 에러: $e');
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
      debugPrint('SearchRepository getTagVideo 에러: $e');
    }
    return _isGetTagVideosSuccess ?? false;
  }

  Future<bool> getUserSearch(String key) async {
    try {
      final repositoryResponse = await SearchRepository().getUserSearch(key);
      _usersResponse = repositoryResponse;

      _isGetUsersSuccess = true;
    } catch (e) {
      debugPrint('SearchRepository getUserSearch 에러: $e');
    }
    return _isGetUsersSuccess ?? false;
  }

  // Future<bool> postFollow(String userId) async {
  //   try {
  //     _isPostSuccess = await FollowRepository().postFollow(userId);

  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('FollowRepository postFollow 에러: $e');
  //   }
  //   return _isPostSuccess ?? false;
  // }

  // Future<bool> deleteFollow(String userId) async {
  //   try {
  //     _isDeleteSuccess = await FollowRepository().deleteFollow(userId);
  //   } catch (e) {
  //     debugPrint('FollowRepository deleteFollow 에러: $e');
  //   }

  //   return _isDeleteSuccess ?? false;
  // }
}
