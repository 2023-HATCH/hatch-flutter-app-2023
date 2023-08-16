import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';

part 'user_list_item.g.dart';

@JsonSerializable()
class UserListItem extends BaseObject<UserListItem> {
  String userId = "";
  String nickname = "";
  String? profileImg;

  UserListItem(this.userId, this.nickname, this.profileImg);

  factory UserListItem.fromJson(Map<String, dynamic> json) =>
      UserListItem(json['userId'], json['nickname'], json['profileImg']);

  Map<String, dynamic> toJson() => _$UserListItemToJson(this);

  @override
  UserListItem fromJson(json) {
    return UserListItem.fromJson(json);
  }
}
