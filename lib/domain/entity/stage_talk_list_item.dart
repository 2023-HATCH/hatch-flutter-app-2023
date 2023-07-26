import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/chat_user_list_item.dart';

part 'stage_talk_list_item.g.dart';

@JsonSerializable()
class StageTalkListItem {
  late String messageId;
  late String content;
  late String createdAt;
  late ChatUserListItem sender;

  StageTalkListItem(
      {required this.content, required this.sender, required this.createdAt});

  factory StageTalkListItem.fromJson(Map<String, dynamic> json) =>
      _$StageTalkListItemFromJson(json);

  Map<String, dynamic> toJson() => _$StageTalkListItemToJson(this);
}
