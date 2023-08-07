import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton_pose_landmark.dart';

// part 'send_skeleton_request.g.dart';

@JsonSerializable()
class SendSkeletonRequest {
  final int playerNum;
  final int frameNum;
  final Map<String, StageSkeletonPoseLandmark> skeleton;

  SendSkeletonRequest({
    required this.playerNum,
    required this.frameNum,
    required this.skeleton,
  });

  factory SendSkeletonRequest.fromRawJson(String str) =>
      SendSkeletonRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendSkeletonRequest.fromJson(Map<String, dynamic> json) =>
      SendSkeletonRequest(
        playerNum: json["playerNum"],
        frameNum: json["frameNum"],
        skeleton: Map.from(json["skeleton"]).map((k, v) =>
            MapEntry<String, StageSkeletonPoseLandmark>(
                k, StageSkeletonPoseLandmark.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "playerNum": playerNum,
        "frameNum": frameNum,
        "skeleton": Map.from(skeleton)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}
