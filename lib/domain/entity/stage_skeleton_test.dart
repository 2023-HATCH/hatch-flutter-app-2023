import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton_pose_test.dart';

part 'stage_skeleton_test.g.dart';

@JsonSerializable()
class StageSkeletonTest {
  List<StageSkeletonPoseTest> poses;

  StageSkeletonTest({required this.poses});

  factory StageSkeletonTest.fromJson(Map<String, dynamic> json) =>
      _$StageSkeletonTestFromJson(json);

  Map<String, dynamic> toJson() => _$StageSkeletonTestToJson(this);
}
