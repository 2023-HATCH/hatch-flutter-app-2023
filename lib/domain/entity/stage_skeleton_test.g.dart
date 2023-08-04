// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_skeleton_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StageSkeletonTest _$StageSkeletonTestFromJson(Map<String, dynamic> json) =>
    StageSkeletonTest(
      poses: (json['poses'] as List<dynamic>)
          .map((e) => StageSkeletonPoseTest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StageSkeletonTestToJson(StageSkeletonTest instance) =>
    <String, dynamic>{
      'poses': instance.poses,
    };
