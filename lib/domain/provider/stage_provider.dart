import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/response/stage_user_list_response.dart';

abstract class StageProvider {
  Future<BaseResponse<StageUserListResponse>> getUserList();
}
