import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/chat_room_list_item.dart';

part 'chat_list_response.g.dart';

@JsonSerializable()
class ChatListResponse {
  List<ChatRoomListItem> chatRooms;

  ChatListResponse({
    required this.chatRooms,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatListResponseToJson(this);
}
