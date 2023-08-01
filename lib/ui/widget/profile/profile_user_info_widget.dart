import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/screen/profile/profile_follow_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileUserInfoWidget extends StatelessWidget {
  ProfileUserInfoWidget({
    super.key,
    required this.index,
  });

  int index;

  late VideoPlayProvider _videoPlayProvider;

  List<String> videoLinks = [
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-2.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-4.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-5.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-3.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-1.mp4',
  ];

  List<String> likes = [
    '6.6천',
    '1만',
    '9.2만',
    '9.4천',
    '2.8만',
  ];

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context);
    UserData user = _videoPlayProvider.videoList[index].user;

    return SizedBox(
      //color: Colors.yellow,
      height: 300,
      child: Center(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: 100,
            height: 100,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  user.profileImg!,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor.purpleColor,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/charactor_popo_default.png',
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 14),
            child: Text(
              user.nickname,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // 위 아래 정렬을 중앙으로 설정
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: const Text("161")),
                        const Text("팔로워"),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileFollowScreen(
                            tapNum: 0, index: 0)), // 사용자 index 넘기기
                  ),
                ),
                GestureDetector(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // 위 아래 정렬을 중앙으로 설정
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: const Text("48.4k")),
                      const Text("팔로잉"),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileFollowScreen(
                            tapNum: 1, index: 0)), // 사용자 index 넘기기
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: OutlinedButton(
                    onPressed: () {
                      // Respond to button press
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      minimumSize: const Size(100, 30), // 원하는 가로 길이와 세로 길이 지정
                    ),
                    child: const Text(
                      "메시지",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Respond to button press
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(30, 30), // 원하는 가로 길이와 세로 길이 지정
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/ic_profile_insta.svg',
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
          const Text("자기소개입니다."),
        ],
      )),
    );
  }
}
