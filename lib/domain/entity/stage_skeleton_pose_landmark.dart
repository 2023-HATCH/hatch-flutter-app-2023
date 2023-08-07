import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StageSkeletonPoseLandmark {
  final int type;
  final double x;
  final double y;
  final double z;
  final double likelihood;

  StageSkeletonPoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.likelihood,
  });

  factory StageSkeletonPoseLandmark.fromRawJson(String str) =>
      StageSkeletonPoseLandmark.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StageSkeletonPoseLandmark.fromJson(Map<String, dynamic> json) =>
      StageSkeletonPoseLandmark(
        type: json["type"]?.toInt(),
        x: json["x"]?.toDouble(),
        y: json["y"]?.toDouble(),
        z: json["z"]?.toDouble(),
        likelihood: json["likelihood"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "x": x,
        "y": y,
        "z": z,
        "likelihood": likelihood,
      };
}
