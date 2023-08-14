import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/stage_music_data.dart';

part 'catch_start_response.g.dart';

@JsonSerializable()
class CatchStartResponse extends BaseObject {
  StageMusicData music;

  CatchStartResponse({
    required this.music,
  });

  factory CatchStartResponse.fromJson(Map<String, dynamic> json) =>
      _$CatchStartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CatchStartResponseToJson(this);

  @override
  fromJson(json) {
    return CatchStartResponse.fromJson(json);
  }
}
