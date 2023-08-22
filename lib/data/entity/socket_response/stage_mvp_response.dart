import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/stage_player_info_list_item.dart';

part 'stage_mvp_response.g.dart';

@JsonSerializable()
class StageMVPResponse extends BaseObject<StageMVPResponse> {
  int mvpPlayerNum;
  List<StagePlayerInfoListItem> playerInfos;

  StageMVPResponse({required this.mvpPlayerNum, required this.playerInfos});

  factory StageMVPResponse.fromJson(Map<String, dynamic> json) =>
      _$StageMVPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StageMVPResponseToJson(this);

  @override
  fromJson(json) {
    return StageMVPResponse.fromJson(json);
  }
}
