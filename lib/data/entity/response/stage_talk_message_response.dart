import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';

part 'stage_talk_message_response.g.dart';

@JsonSerializable()
class StageTalkMessageResponse {
  int page;
  int size;
  List<StageTalkListItem> messeges;

  StageTalkMessageResponse({
    required this.page,
    required this.size,
    required this.messeges,
  });

  factory StageTalkMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$StageTalkMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StageTalkMessageResponseToJson(this);
}
