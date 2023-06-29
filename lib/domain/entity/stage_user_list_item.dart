import 'package:json_annotation/json_annotation.dart';

part 'stage_user_list_item.g.dart';

@JsonSerializable()
class StageUserListItem {
  String userId = "";
  String nickname = "";
  String? profileImg;

  StageUserListItem(
      {required this.userId, required this.nickname, this.profileImg});

  factory StageUserListItem.fromJson(Map<String, dynamic> json) =>
      _$StageUserListItemFromJson(json);

  Map<String, dynamic> toJson() => _$StageUserListItemToJson(this);
}
