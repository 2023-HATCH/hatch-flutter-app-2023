import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:json_annotation/json_annotation.dart';
//
// part 'stage_skeleton_pose_landmark_test.g.dart';

@JsonSerializable()
class StageSkeletonPoseLandmarkTest {
  final PoseLandmarkType type;
  final double x;
  final double y;
  final double z;
  final double likelihood;

  StageSkeletonPoseLandmarkTest({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.likelihood,
  });

  /// Returns an instance of [PoseLandmark] from a given [json].
  factory StageSkeletonPoseLandmarkTest.fromJson(Map<dynamic, dynamic> json) {
    return StageSkeletonPoseLandmarkTest(
      type: PoseLandmarkType.values[json['type'].toInt()],
      x: json['x'],
      y: json['y'],
      z: json['z'],
      likelihood: json['likelihood'] ?? 0.0,
    );
  }

  // Map<String, dynamic> toJson() => _$StageSkeletonPoseLandmarkTestToJson(this);
}
