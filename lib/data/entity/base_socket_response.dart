import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';

class BaseSocketResponse<T> {
  String timeStamp;
  StageType type;
  String message;
  T? data;

  BaseSocketResponse(
      {required this.timeStamp,
      required this.type,
      required this.message,
      this.data});

  factory BaseSocketResponse.fromJson(
      Map<String, dynamic> json, BaseObject? target) {
    return BaseSocketResponse(
      timeStamp: json['timeStamp'],
      type: StageType.values.byName(json['type'].toString()),
      message: json['message'],
      data: target?.fromJson(json['data']),
    );
  }
}
