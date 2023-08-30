import 'package:pocket_pose/config/firebase/i_dynamic_link.dart';
import 'package:pocket_pose/config/firebase/dynamic_link.dart';

class DynamicLinkUtil extends IDynamicLink {
  DynamicLink dynamicLink = DynamicLink();

  static final DynamicLinkUtil _instance = DynamicLinkUtil._internal();

  factory DynamicLinkUtil() => _instance;

  DynamicLinkUtil._internal();

  @override
  Future<String> getShortLink(String uuid) {
    return dynamicLink.getShortLink(uuid);
  }

  @override
  Future<bool> setup() {
    return dynamicLink.setup();
  }
}
