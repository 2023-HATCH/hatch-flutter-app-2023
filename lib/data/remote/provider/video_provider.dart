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
      debugPrint('moon error! VideoProvider getVideos: $e');
    }
  }

  Future<bool> deleteVideo(String videoId) async {
    try {
      _isDeleteSuccess = await VideoRepository().deleteVideo(videoId);
    } catch (e) {
      debugPrint('moon error! VideoProvider deleteVideo: $e');
    }
    return _isDeleteSuccess ?? false;
  }

  Future<void> getView(String videoId) async {
    try {
      await VideoRepository().getView(videoId);

      notifyListeners();
    } catch (e) {
      debugPrint('moon error! VideoProvider getView: $e');
    }
  }
}
