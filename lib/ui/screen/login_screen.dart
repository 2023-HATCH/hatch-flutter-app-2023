//로고 버튼을 눌러 로그인을 실행하고 로그아웃 버튼으로 로그아웃을 처리하는 화면
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pocket_pose/domain/enum/login_platform.dart';
import 'package:pocket_pose/domain/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //현재 로그인한 플랫폼을 저장할 변수를 선언
  LoginPlatform _loginPlatform = LoginPlatform.none;

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

      debugPrint('카카오톡 accessToken ${token.accessToken}');

      //유저 정보 확인
      //로그인을 성공했다면 OAuthToken 으로 accessToken 값을 받아올 수 있음
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

      //로그인 상태값 갱신
      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });
      // 로그인 성공
      authProvider.storeAccessToken(token.accessToken);
    } catch (error) {
      debugPrint('카카오톡으로 로그인 실패 $error');
    }
  }

  void signOut() async {
    //로그인 상태값을 false, 현재 로그인 플랫폼을 none 으로 갱신
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.none:
        break;
    }

    debugPrint('카카오톡 로그아웃');
    setState(() {
      _loginPlatform = LoginPlatform.none;
    });

    // 로그아웃 처리
    authProvider.removeAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);

    debugPrint("토큰${authProvider.accessToken}");
    return authProvider.accessToken != null
        ? Container()
        : Scaffold(
            body: Center(
              child: _loginPlatform != LoginPlatform.none
                  ? _logoutButton()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _loginButton(
                          'kakao_logo',
                          signInWithKakao,
                        )
                      ],
                    ),
            ),
          );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    //버튼에 그림자 효과를 주는 Card 위젯
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      //버튼에 ripple 효과를 주기위해 Card 위젯 자식으로 Ink 위젯
      child: Ink.image(
        image: AssetImage('assets/images/$path.png'),
        width: 60,
        height: 60,
        //onTap 사용을 위해 InkWell 위젯
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          //VoidCallback 을 통해 로그인 처리를 하는 함수를 받음
          onTap: onTap,
        ),
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
