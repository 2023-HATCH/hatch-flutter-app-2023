import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/follow_data.dart';

part 'follow_list_response.g.dart';

@JsonSerializable()
class FollowListResponse {
  final List<FollowData> followerList;
  final List<FollowData> followingList;

  const FollowListResponse({
    required this.followerList,
    required this.followingList,
  });

  factory FollowListResponse.fromJson(Map<String, dynamic> json) =>
      _$FollowListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FollowListResponseToJson(this);
}
