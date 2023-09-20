import 'dart:io';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';

class VideoUploadDialog extends StatefulWidget {
  final String title;
  final String message;
  final File file;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const VideoUploadDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.file,
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoUploadDialogState createState() => _VideoUploadDialogState();
}

class _VideoUploadDialogState extends State<VideoUploadDialog> {
  late CachedVideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    _videoController = CachedVideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        _videoController.setVolume(1.0);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: SizedBox(
                width: 200,
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: CachedVideoPlayer(_videoController),
                      )
                    : CircularProgressIndicator(
                        color: AppColor.purpleColor,
                      ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(widget.message),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
