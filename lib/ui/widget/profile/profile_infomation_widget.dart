import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileInfomationWidget extends StatelessWidget {
  ProfileInfomationWidget({
    super.key,
  });

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
              child: Image.asset(
                'assets/images/profile_profile.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 14),
            child: const Text(
              "chats_chur",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // 위 아래 정렬을 중앙으로 설정
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: const Text("161")),
                      const Text("팔로잉"),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // 위 아래 정렬을 중앙으로 설정
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: const Text("48.4k")),
                    const Text("팔로워"),
                  ],
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
