import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
import 'package:pocket_pose/data/remote/repository/video_repository.dart';

class VideoProvider extends ChangeNotifier {
  VideosResponse? _response;
  bool? _isDeleteSuccess;

  VideosResponse? get response => _response;
  bool? get isDeleteSuccess => _isDeleteSuccess;

  Future<void> getVideos(VideosRequest homeVideosRequest) async {
    try {
      final repositoryResponse =
          await VideoRepository().getVideos(homeVideosRequest);
      _response = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint('VideoProvider getVideos 에러: $e');
    }
  }

  Future<void> deleteVideo(String videoId) async {
    try {
      _isDeleteSuccess = await VideoRepository().deleteVideo(videoId);

      notifyListeners();
    } catch (e) {
      debugPrint('VideoProvider deleteVideo 에러: $e');
    }
  }

  Future<void> getView(String videoId) async {
    try {
      await VideoRepository().getView(videoId);

      notifyListeners();
    } catch (e) {
      debugPrint('VideoProvider getView 에러: $e');
    }
  }
}
