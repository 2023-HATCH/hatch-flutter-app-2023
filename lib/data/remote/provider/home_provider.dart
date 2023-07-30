import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/home_videos_request.dart';
import 'package:pocket_pose/data/entity/response/home_videos_response.dart';
import 'package:pocket_pose/data/remote/repository/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeVideosResponse? _response;

  HomeVideosResponse? get response => _response;

  Future<void> getVideos(HomeVideosRequest homeVideosRequest) async {
    try {
      final repositoryResponse =
          await HomeRepository().getVideos(homeVideosRequest);
      _response = repositoryResponse;

      debugPrint('새 비디오 repositoryResponse $repositoryResponse');
      debugPrint(
          '새 비디오 repositoryResponse ${repositoryResponse.videoList.first.tag}');

      notifyListeners();
    } catch (e) {
      debugPrint('Error logging in: $e');
    }
  }
}
