import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';

part 'stage_user_list_item.g.dart';

@JsonSerializable()
class StageUserListItem extends BaseObject<StageUserListItem> {
  String userId = "";
  String nickname = "";
  String? profileImg;

  StageUserListItem(this.userId, this.nickname, this.profileImg);

  factory StageUserListItem.fromJson(Map<String, dynamic> json) =>
      StageUserListItem(json['userId'], json['nickname'], json['profileImg']);

  Map<String, dynamic> toJson() => _$StageUserListItemToJson(this);

  @override
  StageUserListItem fromJson(json) {
    return StageUserListItem.fromJson(json);
  }
}
