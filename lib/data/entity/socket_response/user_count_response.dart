import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';

part 'user_count_response.g.dart';

@JsonSerializable()
class UserCountResponse extends BaseObject {
  int userCount;

  UserCountResponse({
    required this.userCount,
  });

  factory UserCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UserCountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserCountResponseToJson(this);

  @override
  fromJson(json) {
    return UserCountResponse.fromJson(json);
  }
}
