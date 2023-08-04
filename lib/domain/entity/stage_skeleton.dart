import 'package:json_annotation/json_annotation.dart';

part 'stage_skeleton.g.dart';

@JsonSerializable()
class StageSkeleton {
  double noseX;
  double noseY;
  double noseZ;
  double rightShoulderX;
  double rightShoulderY;
  double rightShoulderZ;
  double rightElbowX;
  double rightElbowY;
  double rightElbowZ;
  double rightWristX;
  double rightWristY;
  double rightWristZ;
  double rightHipX;
  double rightHipY;
  double rightHipZ;
  double rightKneeX;
  double rightKneeY;
  double rightKneeZ;
  double rightAnkleX;
  double rightAnkleY;
  double rightAnkleZ;
  double leftShoulderX;
  double leftShoulderY;
  double leftShoulderZ;
  double leftElbowX;
  double leftElbowY;
  double leftElbowZ;
  double leftWristX;
  double leftWristY;
  double leftWristZ;
  double leftHipX;
  double leftHipY;
  double leftHipZ;
  double leftKneeX;
  double leftKneeY;
  double leftKneeZ;
  double leftAnkleX;
  double leftAnkleY;
  double leftAnkleZ;

  StageSkeleton({
    required this.noseX,
    required this.noseY,
    required this.noseZ,
    required this.rightShoulderX,
    required this.rightShoulderY,
    required this.rightShoulderZ,
    required this.rightElbowX,
    required this.rightElbowY,
    required this.rightElbowZ,
    required this.rightWristX,
    required this.rightWristY,
    required this.rightWristZ,
    required this.rightHipX,
    required this.rightHipY,
    required this.rightHipZ,
    required this.rightKneeX,
    required this.rightKneeY,
    required this.rightKneeZ,
    required this.rightAnkleX,
    required this.rightAnkleY,
    required this.rightAnkleZ,
    required this.leftShoulderX,
    required this.leftShoulderY,
    required this.leftShoulderZ,
    required this.leftElbowX,
    required this.leftElbowY,
    required this.leftElbowZ,
    required this.leftWristX,
    required this.leftWristY,
    required this.leftWristZ,
    required this.leftHipX,
    required this.leftHipY,
    required this.leftHipZ,
    required this.leftKneeX,
    required this.leftKneeY,
    required this.leftKneeZ,
    required this.leftAnkleX,
    required this.leftAnkleY,
    required this.leftAnkleZ,
  });

  factory StageSkeleton.fromJson(Map<String, dynamic> json) =>
      _$StageSkeletonFromJson(json);

  Map<String, dynamic> toJson() => _$StageSkeletonToJson(this);
}
