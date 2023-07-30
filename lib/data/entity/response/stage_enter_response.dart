import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/data/entity/response/stage_talk_message_response.dart';

part 'stage_enter_response.g.dart';

@JsonSerializable()
class StageEnterResponse extends BaseObject<StageEnterResponse> {
  String stageStatus;
  int userCount;
  StageTalkMessageResponse talkMessageData;

  StageEnterResponse({
    required this.stageStatus,
    required this.userCount,
    required this.talkMessageData,
  });

  factory StageEnterResponse.fromJson(Map<String, dynamic> json) =>
      _$StageEnterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StageEnterResponseToJson(this);

  @override
  StageEnterResponse fromJson(json) {
    return StageEnterResponse.fromJson(json);
  }
}
