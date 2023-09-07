import 'package:pocket_pose/domain/entity/video_data.dart';

abstract class ShareProvider {
  Future<VideoData> getVideoDetail(String videoId);
}
