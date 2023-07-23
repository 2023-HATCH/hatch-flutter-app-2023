import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/chat_user_list_item.dart';

part 'chat_detail_list_item.g.dart';

@JsonSerializable()
class ChatDetailListItem {
  String content = "";
  late ChatUserListItem sender;
  String createdAt;

  ChatDetailListItem(
      {required this.content, required this.sender, required this.createdAt});

  factory ChatDetailListItem.fromJson(Map<String, dynamic> json) =>
      _$ChatDetailListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDetailListItemToJson(this);
}
