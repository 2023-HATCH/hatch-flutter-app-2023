import 'package:json_annotation/json_annotation.dart';

part 'stage_skeleton.g.dart';

@JsonSerializable()
class StageSkeleton {
  double noseX;
  double noseY;
  double rightShoulderX;
  double rightShoulderY;
  double rightElbowX;
  double rightElbowY;
  double rightWristX;
  double rightWristY;
  double rightHipX;
  double rightHipY;
  double rightKneeX;
  double rightKneeY;
  double rightAnkleX;
  double rightAnkleY;
  double leftShoulderX;
  double leftShoulderY;
  double leftElbowX;
  double leftElbowY;
  double leftWristX;
  double leftWristY;
  double leftHipX;
  double leftHipY;
  double leftKneeX;
  double leftKneeY;
  double leftAnkleX;
  double leftAnkleY;

  StageSkeleton({
    required this.noseX,
    required this.noseY,
    required this.rightShoulderX,
    required this.rightShoulderY,
    required this.rightElbowX,
    required this.rightElbowY,
    required this.rightWristX,
    required this.rightWristY,
    required this.rightHipX,
    required this.rightHipY,
    required this.rightKneeX,
    required this.rightKneeY,
    required this.rightAnkleX,
    required this.rightAnkleY,
    required this.leftShoulderX,
    required this.leftShoulderY,
    required this.leftElbowX,
    required this.leftElbowY,
    required this.leftWristX,
    required this.leftWristY,
    required this.leftHipX,
    required this.leftHipY,
    required this.leftKneeX,
    required this.leftKneeY,
    required this.leftAnkleX,
    required this.leftAnkleY,
  });

  factory StageSkeleton.fromJson(Map<String, dynamic> json) =>
      _$StageSkeletonFromJson(json);

  Map<String, dynamic> toJson() => _$StageSkeletonToJson(this);
}
