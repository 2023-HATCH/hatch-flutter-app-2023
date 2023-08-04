import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton_landmark_test.dart';

part 'stage_skeleton_pose_test.g.dart';

@JsonSerializable()
class StageSkeletonPoseTest {
  Map<int, StageSkeletonPoseLandmarkTest> landmarks;

  StageSkeletonPoseTest({required this.landmarks});

  factory StageSkeletonPoseTest.fromJson(Map<String, dynamic> json) =>
      _$StageSkeletonPoseTestFromJson(json);

  Map<String, dynamic> toJson() => _$StageSkeletonPoseTestToJson(this);
}
