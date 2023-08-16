import 'package:json_annotation/json_annotation.dart';

part 'send_chat_request.g.dart';

@JsonSerializable()
class SendChatRequest {
  String chatRoomId;
  String content;

  SendChatRequest({
    required this.chatRoomId,
    required this.content,
  });

  factory SendChatRequest.fromJson(Map<String, dynamic> json) =>
      _$SendChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendChatRequestToJson(this);
}
