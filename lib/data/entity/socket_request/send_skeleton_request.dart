import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton.dart';

part 'send_skeleton_request.g.dart';

@JsonSerializable()
class SendSkeletonRequest {
  int playerNum;
  StageSkeleton? skeleton;

  SendSkeletonRequest({
    required this.playerNum,
    this.skeleton,
  });

  factory SendSkeletonRequest.fromJson(Map<String, dynamic> json) =>
      _$SendSkeletonRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendSkeletonRequestToJson(this);
}
