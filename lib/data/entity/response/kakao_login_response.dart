import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'kakao_login_response.g.dart';

@JsonSerializable()
class KaKaoLoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;

  KaKaoLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory KaKaoLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$KaKaoLoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$KaKaoLoginResponseToJson(this);
}
