import 'package:json_annotation/json_annotation.dart';

part 'chat_user_list_item.g.dart';

@JsonSerializable()
class ChatUserListItem {
  String userId = "";
  String nickname = "";
  String? profileImg;

  ChatUserListItem(
      {required this.userId, required this.nickname, this.profileImg});

  factory ChatUserListItem.fromJson(Map<String, dynamic> json) =>
      _$ChatUserListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserListItemToJson(this);
}
