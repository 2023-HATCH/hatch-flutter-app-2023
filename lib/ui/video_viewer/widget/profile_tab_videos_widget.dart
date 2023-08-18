import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/entity/request/profile_videos_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/entity/response/videos_response.dart';
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

  late VideosResponse? _uploadVideos;
  late VideosResponse? _likeVideos;

  bool isVideoLoadingDone = false;

  final List<String> _videoImagePath2 = [
    "profile_video_8",
    "profile_video_10",
    "profile_video_11",
    "profile_video_6",
    "profile_video_8",
    "profile_video_10",
    "profile_video_11",
    "profile_video_6",
    "profile_video_8",
    "profile_video_10",
    "profile_video_11",
    "profile_video_6",
  ];

  Future<bool> _initVideo() async {
    if (!isVideoLoadingDone) {
      // 업로드한 영상 목록 조회
      await _profileProvider.getUploadVideos(ProfileVideosRequest(
          userId: widget._profileResponse.user.userId, page: 0, size: 5));
      // 좋아요한 영상 목록 조회
      // await _profileProvider.getLikeVideos(
      //             ProfileVideosRequest(userId: _userId!, page: 0, size: 5));
      setState(() {
        _uploadVideos = _profileProvider.uploadVideosResponse!;
        _likeVideos = _profileProvider.uploadVideosResponse!;
      });

      isVideoLoadingDone = true;
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    return FutureBuilder<bool>(
        future: _initVideo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _uploadVideos != null
                // && _likeVideos != null
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
                                        _uploadVideos!
                                            .videoList[index].thumbnailUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
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
                                            const Text(
                                              '1.5k',
                                              style: TextStyle(
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
                      childCount: _uploadVideos!.videoList.length,
                    ),
                  )
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
