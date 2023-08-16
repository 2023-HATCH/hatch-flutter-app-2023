import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';

part 'send_chat_response.g.dart';

@JsonSerializable()
class SendChatResponse extends BaseObject {
  String createdAt;
  UserListItem sender;
  String content = "";

  SendChatResponse(
      {required this.createdAt, required this.sender, required this.content});

  factory SendChatResponse.fromJson(Map<String, dynamic> json) =>
      _$SendChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendChatResponseToJson(this);

  @override
  fromJson(json) {
    return SendChatResponse.fromJson(json);
  }
}
