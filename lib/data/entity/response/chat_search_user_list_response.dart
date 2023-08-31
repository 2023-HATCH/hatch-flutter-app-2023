import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/chat_user_list_item.dart';

part 'chat_search_user_list_response.g.dart';

@JsonSerializable()
class ChatSearchUserListResponse
    extends BaseObject<ChatSearchUserListResponse> {
  List<ChatUserListItem> userList;

  ChatSearchUserListResponse({
    required this.userList,
  });

  factory ChatSearchUserListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSearchUserListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSearchUserListResponseToJson(this);

  @override
  ChatSearchUserListResponse fromJson(json) {
    return ChatSearchUserListResponse.fromJson(json);
  }
}
