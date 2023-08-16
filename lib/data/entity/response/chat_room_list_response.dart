import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/chat_room_list_item.dart';

part 'chat_room_list_response.g.dart';

@JsonSerializable()
class ChatRoomListResponse {
  List<ChatRoomListItem> chatRooms;

  ChatRoomListResponse({
    required this.chatRooms,
  });

  factory ChatRoomListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomListResponseToJson(this);
}
