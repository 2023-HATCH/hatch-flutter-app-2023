import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
import 'package:pocket_pose/data/remote/repository/video_repository.dart';

class VideoProvider extends ChangeNotifier {
  VideosResponse? _response;

  VideosResponse? get response => _response;

  Future<void> getVideos(VideosRequest homeVideosRequest) async {
    try {
      final repositoryResponse =
          await VideoRepository().getVideos(homeVideosRequest);
      _response = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint('HomeVideosResponse getVideos 에러: $e');
    }
  }
}
