import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton_pose_landmark.dart';

@JsonSerializable()
class SendSkeletonResponse extends BaseObject {
  String userId;
  int playerNum;
  int frameNum;
  Map<String, StageSkeletonPoseLandmark> skeleton;

  SendSkeletonResponse({
    required this.userId,
    required this.playerNum,
    required this.frameNum,
    required this.skeleton,
  });

  factory SendSkeletonResponse.fromRawJson(String str) =>
      SendSkeletonResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendSkeletonResponse.fromJson(Map<String, dynamic> json) =>
      SendSkeletonResponse(
        userId: json["userId"],
        playerNum: json["playerNum"],
        frameNum: json["frameNum"],
        skeleton: Map.from(json["skeleton"]).map((k, v) =>
            MapEntry<String, StageSkeletonPoseLandmark>(
                k, StageSkeletonPoseLandmark.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "playerNum": playerNum,
        "frameNum": frameNum,
        "skeleton": Map.from(skeleton)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };

  @override
  fromJson(json) {
    return SendSkeletonResponse.fromJson(json);
  }
}
