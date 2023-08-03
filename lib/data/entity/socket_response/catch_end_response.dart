import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';

part 'catch_end_response.g.dart';

@JsonSerializable()
class CatchEndResponse extends BaseObject {
  List<StagePlayerListItem> players;

  CatchEndResponse({
    required this.players,
  });

  factory CatchEndResponse.fromJson(Map<String, dynamic> json) =>
      _$CatchEndResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CatchEndResponseToJson(this);

  @override
  fromJson(json) {
    return CatchEndResponse.fromJson(json);
  }
}
