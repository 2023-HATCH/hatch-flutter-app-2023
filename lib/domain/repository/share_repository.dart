import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/response/share_response.dart';

abstract class ShareRepository {
  Future<BaseResponse<ShareResponse>> getVideoDetail(String videoId);
}
