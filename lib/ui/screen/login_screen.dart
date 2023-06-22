//로고 버튼을 눌러 로그인을 실행하고 로그아웃 버튼으로 로그아웃을 처리하는 화면

import 'package:flutter/cupertino.dart';
import 'package:pocket_pose/domain/enum/login_platform.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //현재 로그인한 플랫폼을 저장할 변수를 선언
  final LoginPlatform _loginPlatform = LoginPlatform.none;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
