import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/profile_videos_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/ui/screen/profile/profile_video_detail_screen.dart';
import 'package:pocket_pose/ui/loader/profile_video_skeleton_loader.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileTabVideosWidget extends StatefulWidget {
  const ProfileTabVideosWidget({
    super.key,
    required ProfileResponse profileResponse,
  }) : _profileResponse = profileResponse;

  final ProfileResponse _profileResponse;

  @override
  State<ProfileTabVideosWidget> createState() => _ProfileTabVideosWidgetState();
}

class _ProfileTabVideosWidgetState extends State<ProfileTabVideosWidget> {
  late ProfileProvider _profileProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);

    _multiVideoPlayProvider.pauseVideo(0);
  }

  Future<bool> _initVideo() async {
    if (mounted) {
      if (!_profileProvider.isVideoLoadingDone) {
        // 업로드한 영상 목록 조회
        debugPrint(
            '1: 프로필 현재 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPages[1]}');

        _profileProvider
            .getUploadVideos(ProfileVideosRequest(
                userId: widget._profileResponse.user.userId,
                page: _multiVideoPlayProvider.currentPages[1],
                size: 100))
            .then((value) {
          final response = _profileProvider.uploadVideosResponse;

          if (mounted) {
            if (response != null) {
              setState(() {
                if (response.videoList.isNotEmpty) {
                  _multiVideoPlayProvider.addVideos(1, response.videoList);
                }
                if (response.isLast) {
                  _multiVideoPlayProvider.isLasts[1] = true;
                  return;
                }
              });
            }
          }

          _multiVideoPlayProvider.currentPages[1]++;
          debugPrint(
              '1: 프로필 다음에 호출될 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPages[1]}');
        });

        debugPrint(
            '2: 프로필 현재 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPages[1]}');

        _profileProvider.isVideoLoadingDone = true;
      }
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _profileProvider.isVideoLoadingDone = false;
    _profileProvider.uploadVideosResponse = null;
    _profileProvider.likeVideosResponse = null;

    debugPrint("프로필 dispose");
    _multiVideoPlayProvider.resetVideoPlayer(1);
    _multiVideoPlayProvider.resetVideoPlayer(2);
  }

  @override
  Widget build(BuildContext context) {
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    return FutureBuilder<bool>(
        future: _initVideo(),
        builder: (context, snapshot) {
          debugPrint('프로필: _initVideo 끝');
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.waiting) {
            return _profileProvider.uploadVideosResponse != null
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          PageRouteWithSlideAnimation pageRouteWithAnimation =
                              PageRouteWithSlideAnimation(ProfileVideoScreen(
                            screenNum: 1,

                            // 업로드 비디오 리스트 전송
                            videoList: _profileProvider
                                .uploadVideosResponse!.videoList,

                            // 처음에 열 페이지 전송
                            initialIndex: index,
                            onRefresh: () {
                              setState(() {});
                            },
                          ));
                          Navigator.push(context,
                              pageRouteWithAnimation.fadeInFadeOutRoute());
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
                                  _profileProvider.uploadVideosResponse!
                                      .videoList[index].thumbnailUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity, loadingBuilder:
                                      (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromRGBO(240, 240, 240, 1),
                                  highlightColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color.fromRGBO(
                                            240, 240, 240, 1)),
                                  ),
                                );
                              }),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _profileProvider.uploadVideosResponse!
                                          .videoList[index].viewCount
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
                      );
                    },
                        childCount: _profileProvider
                            .uploadVideosResponse!.videoList.length))
                :
                // 비디오 부분 로더
                const ProfileVideoSkeletonLoaderWidget();
          } else {
            // 비디오 부분 로더
            return const ProfileVideoSkeletonLoaderWidget();
          }
        });
  }
}
