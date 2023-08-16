import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';

part 'chat_room_response.g.dart';

@JsonSerializable()
class ChatRoomResponse extends BaseObject<ChatRoomResponse> {
  String chatRoomId;

  ChatRoomResponse({
    required this.chatRoomId,
  });

  factory ChatRoomResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomResponseToJson(this);

  @override
  ChatRoomResponse fromJson(json) {
    return ChatRoomResponse.fromJson(json);
  }
}
