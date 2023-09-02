import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/share/dynamic_link.dart';
import 'package:pocket_pose/config/share/kakao_link_with_dynamic_link.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:share_plus/share_plus.dart';

class ShareButtonWidget extends StatefulWidget {
  final VideoData videoData;
  const ShareButtonWidget({super.key, required this.videoData});

  @override
  State<ShareButtonWidget> createState() => _ShareButtonWidgetState();
}

class _ShareButtonWidgetState extends State<ShareButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            ),
          ),
          backgroundColor: Colors.black,
          builder: (context) {
            return SizedBox(
              height: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 23, 20, 8),
                    child: Text(
                      "공유하기",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      Share.share(
                        await DynamicLink().getShortLink(widget.videoData.uuid),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColor.grayColor,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/ic_home_share_link.svg',
                              width: 16,
                              height: 16,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "링크로 공유하기",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      // 카카오톡 실행 가능 여부 확인
                      bool isKakaoTalkSharingAvailable = await ShareClient
                          .instance
                          .isKakaoTalkSharingAvailable();

                      if (isKakaoTalkSharingAvailable) {
                        try {
                          Uri uri = await ShareClient.instance.shareDefault(
                              template:
                                  KakaoLinkWithDynamicLink().buildFeedTemplate(
                            widget.videoData,
                            await DynamicLink()
                                .getShortLink(widget.videoData.uuid),
                          ));
                          await ShareClient.instance.launchKakaoTalk(uri);
                        } catch (error) {
                          debugPrint('mmm 카카오톡 공유 실패 $error');
                        }
                      } else {
                        try {
                          Uri shareUrl = await WebSharerClient.instance
                              .makeDefaultUrl(
                                  template: KakaoLinkWithDynamicLink()
                                      .buildFeedTemplate(
                                          widget.videoData,
                                          await DynamicLink().getShortLink(
                                              widget.videoData.uuid)));
                          await launchBrowserTab(shareUrl, popupOpen: true);
                        } catch (error) {
                          debugPrint('mmm 카카오톡 공유 실패 $error');
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColor.grayColor,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/ic_home_share_kakao.svg',
                              width: 8,
                              height: 8,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "카카오톡으로 공유하기",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      },
      borderRadius: const BorderRadius.all(
        Radius.circular(90.0),
      ),
      child: SvgPicture.asset('assets/icons/ic_home_share.svg'),
    );
  }
}
