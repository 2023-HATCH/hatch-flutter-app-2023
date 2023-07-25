import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';

part 'signin_signup_response.g.dart';

@JsonSerializable()
class SignInSignUpResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;

  SignInSignUpResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SignInSignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInSignUpResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SignInSignUpResponseToJson(this);
}
