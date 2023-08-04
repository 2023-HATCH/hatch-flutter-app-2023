// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_skeleton_pose_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageSkeletonPoseTest _$StageSkeletonPoseTestFromJson(
        Map<String, dynamic> json) =>
    StageSkeletonPoseTest(
      landmarks: (json['landmarks'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k),
            StageSkeletonPoseLandmarkTest.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$StageSkeletonPoseTestToJson(
        StageSkeletonPoseTest instance) =>
    <String, dynamic>{
      'landmarks': instance.landmarks.map((k, e) => MapEntry(k.toString(), e)),
    };
