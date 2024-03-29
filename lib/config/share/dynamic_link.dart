import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/route_manager.dart';
import 'package:pocket_pose/ui/screen/share/share_screen.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLink {
  static final DynamicLink _dynamicLink = DynamicLink._internal();

  factory DynamicLink() {
    return _dynamicLink;
  }

  DynamicLink._internal() {
    setup();
  }

  Future<bool> setup() async {
    bool isExistDynamicLink = await _getInitialDynamicLink();
    _addListener();

    return isExistDynamicLink;
  }

  // 앱 종료 후 리다이랙션
  Future<bool> _getInitialDynamicLink() async {
    final String? deepLink = await getInitialLink();

    if (deepLink != null) {
      var link = (deepLink.contains("fromKakao"))
          ? "https://hatch2023pocketpose.page.link/${deepLink.substring(deepLink.length - 4)}"
          : deepLink;

      PendingDynamicLinkData? dynamicLinkData =
          await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(link));

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
  void _redirectScreen(PendingDynamicLinkData dynamicLinkData) async {
    String dynamicLink = dynamicLinkData.link.toString();

    // 카카오 공유로부터 리다이렉션
    if (dynamicLink.contains("fromKakao")) {
      // 실행중인 영상 있는지 확인
      //

      var link =
          "https://hatch2023pocketpose.page.link/${dynamicLink.substring(dynamicLink.length - 4)}";

      await FirebaseDynamicLinks.instance
          .getDynamicLink(Uri.parse(link))
          .then((value) {
        String videoUuid = value!.link.path.split('/').last;
        Get.to(() => ShareScreen(
              videoUuid: videoUuid,
            ));
        return null;
      });
    }
    // 링크 공유로부터 리다이렉션
    else {
      String videoUuid = dynamicLinkData.link.path.split('/').last;
      Get.to(() => ShareScreen(
            videoUuid: videoUuid,
          ));
    }
  }

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
