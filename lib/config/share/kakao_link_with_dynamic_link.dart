import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';

class KakaoLinkWithDynamicLink {
  static final KakaoLinkWithDynamicLink _kakaoLink =
      KakaoLinkWithDynamicLink._internal();

  factory KakaoLinkWithDynamicLink() {
    return _kakaoLink;
  }

  KakaoLinkWithDynamicLink._internal();

  Future<bool> isKakaotalkInstalled() async {
    bool installed = await isKakaotalkInstalled();
    return installed;
  }

  FeedTemplate buildFeedTemplate(VideoData videoData, String link) {
    return FeedTemplate(
      content: Content(
        title: videoData.title,
        description: videoData.tag,
        imageUrl: Uri.parse(videoData.thumbnailUrl),
        link: Link(
            webUrl: Uri.parse(link),
            mobileWebUrl: Uri.parse(link),
            androidExecutionParams: {'fromKakao': link},
            iosExecutionParams: {'fromKakao': link}),
      ),
      itemContent: ItemContent(
        profileText: videoData.user.nickname,
        profileImageUrl: Uri.parse(videoData.user.profileImg ??
            'https://github.com/2023-HATCH/hatch-flutter-app-2023/assets/61674991/5f67a84c-f834-4214-86ed-873cc599f31b'),
      ),
      social: Social(
          likeCount: videoData.likeCount,
          viewCount: videoData.viewCount,
          commentCount: videoData.commentCount),
    );
  }
}
