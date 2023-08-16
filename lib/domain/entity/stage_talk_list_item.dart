import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';

part 'stage_talk_list_item.g.dart';

@JsonSerializable()
class StageTalkListItem {
  String? messageId = "";
  String content;
  String? createdAt = "";
  UserListItem sender;

  StageTalkListItem(
      {this.messageId,
      required this.content,
      required this.sender,
      this.createdAt});

  factory StageTalkListItem.fromJson(Map<String, dynamic> json) =>
      _$StageTalkListItemFromJson(json);

  Map<String, dynamic> toJson() => _$StageTalkListItemToJson(this);
}
