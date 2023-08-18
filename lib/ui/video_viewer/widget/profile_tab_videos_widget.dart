import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/profile_videos_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/ui/video_viewer/screen/video_my_screen.dart';
import 'package:pocket_pose/ui/video_viewer/screen/video_someone_screen.dart';
import 'package:pocket_pose/ui/video_viewer/widget/profile_video_skeleton_loader_widget.dart';
import 'package:provider/provider.dart';

class ProfileTabVideosWidget extends StatefulWidget {
  const ProfileTabVideosWidget({
    super.key,
    required int index,
    required TabController tabController,
    required ProfileResponse profileResponse,
  })  : _index = index,
        _tabController = tabController,
        _profileResponse = profileResponse;

  final int _index;
  final TabController _tabController;
  final ProfileResponse _profileResponse;

  @override
  State<ProfileTabVideosWidget> createState() => _ProfileTabVideosWidgetState();
}

class _ProfileTabVideosWidgetState extends State<ProfileTabVideosWidget> {
  late ProfileProvider _profileProvider;

  Future<bool> _initVideo() async {
    if (!_profileProvider.isVideoLoadingDone) {
      // 업로드한 영상 목록 조회
      _profileProvider.getUploadVideos(ProfileVideosRequest(
          userId: widget._profileResponse.user.userId, page: 0, size: 5));

      // 좋아요한 영상 목록 조회
      _profileProvider.getLikeVideos(ProfileVideosRequest(
          userId: widget._profileResponse.user.userId, page: 0, size: 5));

      _profileProvider.isVideoLoadingDone = true;
    }
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _profileProvider.isVideoLoadingDone = false;
    _profileProvider.uploadVideosResponse = null;
    _profileProvider.likeVideosResponse = null;
  }

  @override
  Widget build(BuildContext context) {
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    return FutureBuilder<bool>(
        future: _initVideo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.waiting) {
            return _profileProvider.uploadVideosResponse != null &&
                    _profileProvider.likeVideosResponse != null
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return AnimatedBuilder(
                        animation: widget._tabController.animation!,
                        builder: (context, child) {
                          final animation = widget._tabController.animation!;
                          return ScaleTransition(
                            scale: widget._index == 0
                                ? Tween<double>(begin: 1.0, end: 0.0).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutQuart,
                                    ),
                                  )
                                : Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutQuart,
                                    ),
                                  ),
                            child: GestureDetector(
                              onTap: () {
                                widget._profileResponse.profile.isMe
                                    ? //내 프로필이면

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VideoMyScreen(
                                                index:
                                                    0))) //사용자 index 값 넣기 (0은 임시 값)

                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoSomeoneScreen(
                                                    index:
                                                        0))); //사용자 index 값 넣기 (0은 임시 값)
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Image.network(
                                        widget._index == 0
                                            ? _profileProvider
                                                .uploadVideosResponse!
                                                .videoList[index]
                                                .thumbnailUrl
                                            : _profileProvider
                                                .likeVideosResponse!
                                                .videoList[index]
                                                .thumbnailUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity, loadingBuilder:
                                            (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: 0.5, // 크기를 조절할 값 (0.0 ~ 1.0)
                                          strokeWidth: 2.0, // 인디케이터 선의 굵기
                                          color: AppColor.purpleColor,
                                        ),
                                      );
                                    }),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ic_profile_heart.svg',
                                            width: 16,
                                            height: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget._index == 0
                                                ? _profileProvider
                                                    .uploadVideosResponse!
                                                    .videoList[index]
                                                    .likeCount
                                                    .toString()
                                                : _profileProvider
                                                    .likeVideosResponse!
                                                    .videoList[index]
                                                    .likeCount
                                                    .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                        childCount: widget._index == 0
                            ? _profileProvider
                                .uploadVideosResponse!.videoList.length
                            : _profileProvider
                                .likeVideosResponse!.videoList.length))
                :
                // 비디오 부분 로더
                ProfileVideoSkeletonLoaderWidget(
                    index: widget._index, tabController: widget._tabController);
          } else {
            // 비디오 부분 로더
            return ProfileVideoSkeletonLoaderWidget(
                index: widget._index, tabController: widget._tabController);
          }
        });
  }
}
