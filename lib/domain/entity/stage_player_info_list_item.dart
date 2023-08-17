import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';

part 'stage_player_info_list_item.g.dart';

@JsonSerializable()
class StagePlayerInfoListItem {
  int playerNum;
  double similarity;
  UserListItem player;

  StagePlayerInfoListItem(
      {required this.playerNum,
      required this.similarity,
      required this.player});

  factory StagePlayerInfoListItem.fromJson(Map<String, dynamic> json) =>
      _$StagePlayerInfoListItemFromJson(json);

  Map<String, dynamic> toJson() => _$StagePlayerInfoListItemToJson(this);
}
