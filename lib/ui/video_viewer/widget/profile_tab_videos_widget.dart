import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/ui/video_viewer/screen/video_someone_screen.dart';

class ProfileTabVideosWidget extends StatelessWidget {
  const ProfileTabVideosWidget({
    super.key,
    required int index,
    required TabController tabController,
    required List<String> videoImagePath1,
    required List<String> videoImagePath2,
  })  : _index = index,
        _tabController = tabController,
        _videoImagePath1 = videoImagePath1,
        _videoImagePath2 = videoImagePath2;

  final int _index;
  final TabController _tabController;
  final List<String> _videoImagePath1;
  final List<String> _videoImagePath2;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, child) {
              final animation = _tabController.animation!;
              return ScaleTransition(
                scale: _index == 0
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoSomeoneScreen(
                                index: 0))); //사용자 index 값 넣기 (0은 임시 값)

                    // isMe로 본인 페이지인지 확인 후 변경
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
                        Image.asset(
                          "assets/images/${_videoImagePath1[index]}.png",
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
        childCount: _videoImagePath2.length,
      ),
    );
  }
}