import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/stage_talk_message_request.dart';
import 'package:pocket_pose/data/entity/response/stage_talk_message_response.dart';

abstract class StageTalkRepository {
  Future<BaseResponse<StageTalkMessageResponse>> getTalkMessages(
      StageTalkMessageRequest request);
}
