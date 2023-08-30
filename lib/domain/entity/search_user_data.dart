import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'search_user_data.g.dart';

@JsonSerializable()
class SearchUserData {
  final UserData user;
  final String? introduce;

  SearchUserData({
    required this.user,
    required this.introduce,
  });

  factory SearchUserData.fromJson(Map<String, dynamic> json) =>
      _$SearchUserDataFromJson(json);
  Map<String, dynamic> toJson() => _$SearchUserDataToJson(this);
}
