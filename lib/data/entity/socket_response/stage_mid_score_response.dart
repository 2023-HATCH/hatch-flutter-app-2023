import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/stage_player_info_list_item.dart';

part 'stage_mid_score_response.g.dart';

@JsonSerializable()
class StageMidScoreResponse extends BaseObject<StageMidScoreResponse> {
  int mvpPlayerNum;
  List<StagePlayerInfoListItem> playerInfos;

  StageMidScoreResponse(
      {required this.mvpPlayerNum, required this.playerInfos});

  factory StageMidScoreResponse.fromJson(Map<String, dynamic> json) =>
      _$StageMidScoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StageMidScoreResponseToJson(this);

  @override
  fromJson(json) {
    return StageMidScoreResponse.fromJson(json);
  }
}
