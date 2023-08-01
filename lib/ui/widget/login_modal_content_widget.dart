import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:provider/provider.dart';

class LoginModalContent extends StatefulWidget {
  const LoginModalContent({super.key});

  @override
  State<LoginModalContent> createState() => _LoginModalContentState();
}

class _LoginModalContentState extends State<LoginModalContent> {
  late KaKaoLoginProvider _loginProvider;

  @override
  Widget build(BuildContext context) {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                //bottom sheet 없애기
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(18, 18, 0, 0),
                child: SvgPicture.asset(
                  'assets/icons/ic_exit.svg',
                  width: 14,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 14, 0, 14),
              child: const Text(
                "Pocket Pose 가입하기",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
              child: const Text(
                "간편하게 로그인하고 다양한 서비스를 이용해보세요.",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
              child: SvgPicture.asset(
                'assets/images/kakao_login_popo.svg',
                width: 150,
              ),
            ),
            _loginButton(
              'kakao_login',
              () {
                _loginProvider.signIn();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return InkWell(
      //VoidCallback 을 통해 로그인 처리를 하는 함수를 받음
      onTap: onTap,
      child: Image.asset(
        'assets/images/$path.png',
      ),
    );
  }
}
