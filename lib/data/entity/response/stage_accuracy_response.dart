import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_accuracy_data.dart';

part 'stage_accuracy_response.g.dart';

@JsonSerializable()
class StageAccuracyResponse {
  final StageAccuracyData data;
  String timeStamp;
  @JsonKey(name: 'code')
  final String code;
  String message;

  StageAccuracyResponse(
      {required this.data,
      required this.timeStamp,
      required this.code,
      required this.message});

  factory StageAccuracyResponse.fromJson(Map<String, dynamic> json) =>
      _$StageAccuracyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StageAccuracyResponseToJson(this);
}
