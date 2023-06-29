import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_user_list_item.dart';

part 'stage_user_list_response.g.dart';

@JsonSerializable()
class StageUserListResponse {
  List<StageUserListItem>? list;

  StageUserListResponse({
    required this.list,
  });

  factory StageUserListResponse.fromJson(Map<String, dynamic> json) =>
      _$StageUserListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StageUserListResponseToJson(this);
}
