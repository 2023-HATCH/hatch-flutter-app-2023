import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';

part 'chat_detail_list_item.g.dart';

@JsonSerializable()
class ChatDetailListItem {
  String? chatMessageId;
  String createdAt;
  UserListItem sender;
  String content = "";

  ChatDetailListItem(
      {this.chatMessageId,
      required this.createdAt,
      required this.sender,
      required this.content});

  factory ChatDetailListItem.fromJson(Map<String, dynamic> json) =>
      _$ChatDetailListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDetailListItemToJson(this);
}
