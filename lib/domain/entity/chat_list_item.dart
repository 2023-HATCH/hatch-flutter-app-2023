import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/chat_user_list_item.dart';

part 'chat_list_item.g.dart';

@JsonSerializable()
class ChatListItem {
  String chatRoomId = "";
  late ChatUserListItem opponentUser;
  String? recentContent;

  ChatListItem(
      {required this.chatRoomId,
      required this.opponentUser,
      this.recentContent});

  factory ChatListItem.fromJson(Map<String, dynamic> json) =>
      _$ChatListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChatListItemToJson(this);
}
