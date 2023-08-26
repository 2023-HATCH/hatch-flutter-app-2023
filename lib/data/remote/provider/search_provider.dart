import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/follow_list_response.dart';
import 'package:pocket_pose/data/remote/repository/follow_repository.dart';
import 'package:pocket_pose/data/remote/repository/search_repository.dart';

class SearchProvider extends ChangeNotifier {
  List<String>? _tagResponse;
  bool? _isGetTagSuccess;
  // bool? _isPostSuccess;
  // bool? _isDeleteSuccess;

  List<String>? get tagResponse => _tagResponse;
  bool? get isGetSuccess => _isGetTagSuccess;
  // bool? get isPostSuccess => _isPostSuccess;
  // bool? get isDeleteSuccess => _isDeleteSuccess;

  Future<bool> getTags() async {
    try {
      final repositoryResponse = await SearchRepository().getTags();
      _tagResponse = repositoryResponse;

      _isGetTagSuccess = true;
    } catch (e) {
      debugPrint('SearchRepository getTags 에러: $e');
    }
    return _isGetTagSuccess ?? false;
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
