import 'package:json_annotation/json_annotation.dart';

part 'profile_data.g.dart';

@JsonSerializable()
class ProfileData {
  final bool isMe;
  final String? introduce;
  final String? instagramId;
  final String? twitterId;
  final int followingCount;
  final int followerCount;
  final bool isFollowing;

  ProfileData({
    required this.isMe,
    required this.introduce,
    required this.instagramId,
    required this.twitterId,
    required this.followingCount,
    required this.followerCount,
    required this.isFollowing,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
