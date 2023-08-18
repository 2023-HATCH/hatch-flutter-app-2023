import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/profile_data.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  final UserData user;
  final ProfileData profile;

  const ProfileResponse({
    required this.user,
    required this.profile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
