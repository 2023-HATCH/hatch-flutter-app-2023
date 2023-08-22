import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'follow_data.g.dart';

@JsonSerializable()
class FollowData {
  final UserData user;
  final String introduce;
  late bool isFollowing;

  FollowData({
    required this.user,
    required this.introduce,
    required this.isFollowing,
  });

  factory FollowData.fromJson(Map<String, dynamic> json) =>
      _$FollowDataFromJson(json);
  Map<String, dynamic> toJson() => _$FollowDataToJson(this);
}
