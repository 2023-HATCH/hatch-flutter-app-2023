import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/follow_data.dart';

part 'follow_list_response.g.dart';

@JsonSerializable()
class FollowListResponse {
  final List<FollowData> followList;

  const FollowListResponse({
    required this.followList,
  });

  factory FollowListResponse.fromJson(Map<String, dynamic> json) =>
      _$FollowListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FollowListResponseToJson(this);
}
