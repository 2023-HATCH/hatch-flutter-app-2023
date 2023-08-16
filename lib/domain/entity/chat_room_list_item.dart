import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';

part 'chat_room_list_item.g.dart';

@JsonSerializable()
class ChatRoomListItem {
  String chatRoomId;
  UserListItem opponentUser;
  String? recentContent = "";
  String? recentSendAt = "";

  ChatRoomListItem(
      {required this.chatRoomId,
      required this.opponentUser,
      required this.recentContent,
      required this.recentSendAt});

  factory ChatRoomListItem.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomListItemToJson(this);
}
