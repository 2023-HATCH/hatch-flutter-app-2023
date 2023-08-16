import 'package:json_annotation/json_annotation.dart';

part 'chat_room_request.g.dart';

@JsonSerializable()
class ChatRoomRequest {
  String opponentUserId;

  ChatRoomRequest({
    required this.opponentUserId,
  });

  factory ChatRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomRequestToJson(this);
}
