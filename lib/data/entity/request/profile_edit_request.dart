import 'package:json_annotation/json_annotation.dart';

part 'profile_edit_request.g.dart';

@JsonSerializable()
class ProfileEditRequest {
  String introduce;
  String instagramId;
  String twitterId;

  ProfileEditRequest({
    required this.introduce,
    required this.instagramId,
    required this.twitterId,
  });

  factory ProfileEditRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileEditRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileEditRequestToJson(this);
}
