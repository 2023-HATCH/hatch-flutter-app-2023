import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/stage_user_list_item.dart';

part 'stage_user_list_response.g.dart';

@JsonSerializable()
class StageUserListResponse extends BaseObject<StageUserListResponse> {
  List<StageUserListItem>? list;

  StageUserListResponse(
    this.list,
  );
  factory StageUserListResponse.fromJson(List<dynamic> json) =>
      StageUserListResponse(
          json.map((e) => StageUserListItem.fromJson(e)).toList());

  Map<String, dynamic> toJson() => _$StageUserListResponseToJson(this);

  @override
  StageUserListResponse fromJson(json) {
    return StageUserListResponse.fromJson(json);
  }
}
