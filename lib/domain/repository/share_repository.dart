import 'package:pocket_pose/domain/entity/video_data.dart';

abstract class ShareRepository {
  Future<VideoData> getVideoDetail(String videoId);
}
