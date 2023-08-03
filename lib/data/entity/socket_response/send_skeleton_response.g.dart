// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_skeleton_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendSkeletonResponse _$SendSkeletonResponseFromJson(
        Map<String, dynamic> json) =>
    SendSkeletonResponse(
      userId: json['userId'] as String,
      playerNum: json['playerNum'] as int,
      skeleton: json['skeleton'] == null
          ? null
          : StageSkeleton.fromJson(json['skeleton'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendSkeletonResponseToJson(
        SendSkeletonResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'playerNum': instance.playerNum,
      'skeleton': instance.skeleton,
    };
