import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/route_manager.dart';
import 'package:pocket_pose/config/firebase/i_dynamic_link.dart';
import 'package:pocket_pose/ui/screen/share_screen.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLink extends IDynamicLink {
  @override
  Future<bool> setup() async {
    bool isExistDynamicLink = await _getInitialDynamicLink();
    _addListener();

    return isExistDynamicLink;
  }

  // 앱 종료 후 리다이랙션
  Future<bool> _getInitialDynamicLink() async {
    final String? deepLink = await getInitialLink();

    if (deepLink != null) {
      PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks
          .instance
          .getDynamicLink(Uri.parse(deepLink));

      if (dynamicLinkData != null) {
        _redirectScreen(dynamicLinkData);

        return true;
      }
    }

    return false;
  }

  void _addListener() {
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      _redirectScreen(dynamicLinkData);
    }).onError((error) {
      log("mmm share linek error: $error");
    });
  }

  // 앱 실행 중 리다이렉션
  void _redirectScreen(PendingDynamicLinkData dynamicLinkData) {
    String videoUuid = dynamicLinkData.link.path.split('/').last;
    Get.to(() => ShareScreen(
          videoUuid: videoUuid,
        ));
  }

  @override
  Future<String> getShortLink(String uuid) async {
    String dynamicLinkPrefix = 'https://hatch2023pocketpose.page.link';
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('$dynamicLinkPrefix/$uuid'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.pocketpose',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.pocketPose',
        minimumVersion: '0',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }
}
