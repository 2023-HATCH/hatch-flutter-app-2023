import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoUploadDialog extends StatelessWidget {
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

  Future<Uint8List> _generateThumbnail(File videoFile) async {
    Uint8List? thumbnailBytes;
    try {
      thumbnailBytes = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
        maxHeight: 400,
      );
    } catch (e) {
      // 비디오에서 썸네일을 생성할 수 없는 경우 임시 이미지 생성
      final image = File('assets/images/placeholder.png');
      thumbnailBytes = await image.readAsBytes();
    }
    return thumbnailBytes!;
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
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 400,
              color: Colors.black,
              child: Center(
                child: FutureBuilder<Uint8List>(
                  future: _generateThumbnail(file),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final thumbnailBytes = snapshot.data!;
                      return Image.memory(
                        thumbnailBytes,
                        fit: BoxFit.fill,
                      );
                    } else {
                      return CircularProgressIndicator(
                          color: AppColor.purpleColor);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(message),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
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
                    onPressed: onConfirm,
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
}
