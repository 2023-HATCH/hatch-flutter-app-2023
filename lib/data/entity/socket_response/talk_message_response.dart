import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/chat_user_list_item.dart';

part 'talk_message_response.g.dart';

@JsonSerializable()
class TalkMessageResponse extends BaseObject {
  String content;
  ChatUserListItem sender;

  TalkMessageResponse({
    required this.content,
    required this.sender,
  });

  factory TalkMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$TalkMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TalkMessageResponseToJson(this);

  @override
  fromJson(json) {
    return TalkMessageResponse.fromJson(json);
  }
}
