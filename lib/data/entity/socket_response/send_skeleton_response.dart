import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton.dart';

part 'send_skeleton_response.g.dart';

@JsonSerializable()
class SendSkeletonResponse {
  String userId;
  int playerNum;
  StageSkeleton? skeleton;

  SendSkeletonResponse({
    required this.userId,
    required this.playerNum,
    this.skeleton,
  });

  factory SendSkeletonResponse.fromJson(Map<String, dynamic> json) =>
      _$SendSkeletonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendSkeletonResponseToJson(this);
}
