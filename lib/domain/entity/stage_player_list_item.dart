import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';

part 'stage_player_list_item.g.dart';

@JsonSerializable()
class StagePlayerListItem extends BaseObject<StagePlayerListItem> {
  int? playerNum;
  String userId = "";
  String nickname = "";
  String? profileImg;

  StagePlayerListItem(
      {this.playerNum,
      required this.userId,
      required this.nickname,
      required this.profileImg});

  factory StagePlayerListItem.fromJson(Map<String, dynamic> json) =>
      _$StagePlayerListItemFromJson(json);

  Map<String, dynamic> toJson() => _$StagePlayerListItemToJson(this);

  @override
  StagePlayerListItem fromJson(json) {
    return StagePlayerListItem.fromJson(json);
  }
}
