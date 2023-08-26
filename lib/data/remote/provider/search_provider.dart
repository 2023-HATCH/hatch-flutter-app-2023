import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/follow_list_response.dart';
import 'package:pocket_pose/data/remote/repository/follow_repository.dart';
import 'package:pocket_pose/data/remote/repository/search_repository.dart';

import '../../entity/request/videos_request.dart';
import '../../entity/response/videos_response.dart';

class SearchProvider extends ChangeNotifier {
  List<String>? _tagsResponse;
  VideosResponse? _tagVideosResponse;

  bool? _isGetTagsSuccess;
  bool? _isGetTagVideosSuccess;
  // bool? _isPostSuccess;
  // bool? _isDeleteSuccess;

  List<String>? get tagResponse => _tagsResponse;
  bool? get isGetSuccess => _isGetTagsSuccess;
  bool? get isGetTagVideosSuccess => _isGetTagVideosSuccess;
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

  Future<bool> getTagVideos(
      String tag, VideosRequest searchVideosRequest) async {
    try {
      final repositoryResponse =
          await SearchRepository().getTagVideos(tag, searchVideosRequest);
      _tagVideosResponse = repositoryResponse;

      _isGetTagVideosSuccess = true;
    } catch (e) {
      debugPrint('SearchRepository getTagVideo 에러: $e');
    }
    return _isGetTagVideosSuccess ?? false;
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
