// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_skeleton_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendSkeletonRequest _$SendSkeletonRequestFromJson(Map<String, dynamic> json) =>
    SendSkeletonRequest(
      playerNum: json['playerNum'] as int,
      skeleton: json['skeleton'] == null
          ? null
          : StageSkeleton.fromJson(json['skeleton'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendSkeletonRequestToJson(
        SendSkeletonRequest instance) =>
    <String, dynamic>{
      'playerNum': instance.playerNum,
      'skeleton': instance.skeleton,
    };
