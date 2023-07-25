import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/chat_list_item.dart';

part 'chat_list_response.g.dart';

@JsonSerializable()
class ChatListResponse {
  List<ChatListItem> list;

  ChatListResponse({
    required this.list,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatListResponseToJson(this);
}
