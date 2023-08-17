import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'user_profile_data.g.dart';

@JsonSerializable()
class UserProfileData {
  final UserData user;
  final bool isMe;
  final String introduce;
  final String instagramId;
  final String twitterId;
  final int followingCount;
  final int followerCount;
  final DateTime createdAt;
  final DateTime modifiedAt;

  UserProfileData({
    required this.user,
    required this.isMe,
    required this.introduce,
    required this.instagramId,
    required this.twitterId,
    required this.followingCount,
    required this.followerCount,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileDataToJson(this);
}
