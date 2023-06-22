import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pocket_pose/domain/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginModalContent extends StatefulWidget {
  const LoginModalContent({super.key});

  @override
  State<LoginModalContent> createState() => _LoginModalContentState();
}

class _LoginModalContentState extends State<LoginModalContent> {
  late AuthProvider authProvider;

  void signInWithKakao() async {
    try {
      //카카오톡 설치 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          //카카오톡이 설치되어 있다면 카카오톡을 실행하여 로그인
          ? await UserApi.instance.loginWithKakaoTalk()
          //카카오톡이 설치되어 있지 않다면 웹으로 로그인
          : await UserApi.instance.loginWithKakaoAccount();

      // 로그인 성공
      authProvider.storeAccessToken(token.accessToken);

      //로그인을 성공했다면 OAuthToken 으로 accessToken 값을 받아올 수 있음
      debugPrint('카카오톡 로그인 성공! accessToken:${token.accessToken}');

      //유저 정보 확인
      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      //토큰 값으로 유저정보를 확인하는 요청을 보내면 이름과 이메일 정보를 얻을 수 있음
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      debugPrint(profileInfo.toString());

      //bottom sheet 없애기
      Navigator.pop(context);
    } catch (error) {
      debugPrint('카카오톡으로 로그인 실패 $error');
    }
  }

  void signOut() async {
    //로그아웃
    debugPrint('카카오톡 로그아웃');
    authProvider.removeAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);

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
              signInWithKakao,
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

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}
