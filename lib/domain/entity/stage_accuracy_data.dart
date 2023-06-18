import 'package:json_annotation/json_annotation.dart';

part 'stage_accuracy_data.g.dart';

@JsonSerializable()
class StageAccuracyData {
  double similarity;

  StageAccuracyData({required this.similarity});

  factory StageAccuracyData.fromJson(Map<String, dynamic> json) =>
      _$StageAccuracyDataFromJson(json);
  Map<String, dynamic> toJson() => _$StageAccuracyDataToJson(this);
}
