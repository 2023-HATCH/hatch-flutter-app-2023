import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';

@JsonSerializable()
class SendSkeletonResponse extends BaseObject {
  String userId;
  int playerNum;
  int frameNum;
  Map<PoseLandmarkType, PoseLandmark>? skeleton;

  SendSkeletonResponse({
    required this.userId,
    required this.playerNum,
    required this.frameNum,
    this.skeleton,
  });

  factory SendSkeletonResponse.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, dynamic>> skeletonMap = json['skeleton'];
    Map<PoseLandmarkType, PoseLandmark> resultMap = {};

    skeletonMap.forEach((key, value) {
      if (value is String) {
        var keyType = PoseLandmarkType.values[int.parse(key)];
        var valueMap = PoseLandmark.fromJson(value);
        resultMap[keyType] = valueMap;
      }
    });

    return SendSkeletonResponse(
      userId: json['userId'],
      playerNum: json['playerNum'],
      frameNum: json['frameNum'],
      skeleton: resultMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "playerNum": playerNum,
      "frameNum": frameNum,
      "skeleton": skeleton
    };
  }

  @override
  fromJson(json) {
    return SendSkeletonResponse.fromJson(json);
  }
}
