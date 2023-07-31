import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';

part 'stage_talk_message_response.g.dart';

@JsonSerializable()
class StageTalkMessageResponse extends BaseObject<StageTalkMessageResponse> {
  int page;
  int size;
  List<StageTalkListItem>? messages;

  StageTalkMessageResponse({
    required this.page,
    required this.size,
    required this.messages,
  });

  factory StageTalkMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$StageTalkMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StageTalkMessageResponseToJson(this);

  @override
  StageTalkMessageResponse fromJson(json) {
    return StageTalkMessageResponse.fromJson(json);
  }
}
