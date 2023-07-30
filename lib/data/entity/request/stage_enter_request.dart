import 'package:json_annotation/json_annotation.dart';

part 'stage_enter_request.g.dart';

@JsonSerializable()
class StageEnterRequest {
  int page;
  int size;

  StageEnterRequest({
    required this.page,
    required this.size,
  });

  factory StageEnterRequest.fromJson(Map<String, dynamic> json) =>
      _$StageEnterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StageEnterRequestToJson(this);
}
