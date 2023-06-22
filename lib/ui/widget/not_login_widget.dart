import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';

class NotLoginWidget extends StatelessWidget {
  const NotLoginWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 100,
          ),
          const Text("로그인 후 이용 가능합니다."),
          Container(
            margin: const EdgeInsets.all(14), // 원하는 margin 값으로 설정
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColor.mainPurpleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(140, 40),
              ),
              onPressed: () {},
              child: const Text(
                "로그인",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
