import 'package:pocket_pose/data/entity/base_object.dart';

class BaseResponse<T> {
  String timeStamp;
  String code;
  String message;
  T data;

  BaseResponse(
      {required this.timeStamp,
      required this.code,
      required this.message,
      required this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json, BaseObject target) {
    return BaseResponse(
      timeStamp: json['timeStamp'],
      code: json['code'],
      message: json['message'],
      data: target.fromJson(json['data']),
    );
  }
}
