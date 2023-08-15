import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/stage_enter_request.dart';
import 'package:pocket_pose/data/entity/response/stage_enter_response.dart';
import 'package:pocket_pose/data/entity/response/stage_user_list_response.dart';

abstract class StageProvider {
  Future<BaseResponse<StageUserListResponse>> getUserList();
  Future<BaseResponse<StageEnterResponse>> getStageEnter(
      StageEnterRequest request);
  Future<void> getStageCatch();
}
