import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String uuid;
  final String nickname;
  final String? profileImg;
  final String? email;

  const UserData({
    required this.uuid,
    required this.nickname,
    required this.profileImg,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
