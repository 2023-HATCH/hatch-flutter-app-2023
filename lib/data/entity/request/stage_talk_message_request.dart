import 'package:json_annotation/json_annotation.dart';

part 'stage_talk_message_request.g.dart';

@JsonSerializable()
class StageTalkMessageRequest {
  int page;
  int size;

  StageTalkMessageRequest({
    required this.page,
    required this.size,
  });

  factory StageTalkMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$StageTalkMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StageTalkMessageRequestToJson(this);
}
