import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final String userId;
  final String nickname;
  final String? profileImg;
  final String? email;

  const UserData({
    required this.userId,
    required this.nickname,
    required this.profileImg,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
