import 'package:json_annotation/json_annotation.dart';

part 'home_video_list_request.g.dart';

@JsonSerializable()
class HomeVidepListRequest {
  final int page;
  final int size;

  const HomeVidepListRequest({
    required this.page,
    required this.size,
  });

  factory HomeVidepListRequest.fromJson(Map<String, dynamic> json) =>
      _$HomeVidepListRequestFromJson(json);
  Map<String, dynamic> toJson() => _$HomeVidepListRequestToJson(this);
}
