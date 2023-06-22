import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/domain/provider/auth_provider.dart';
import 'package:pocket_pose/ui/widget/not_login_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);

    return authProvider.accessToken != null
        //토큰이 존재할 경우
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent, //appBar 투명색
              elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
              actions: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                    child:
                        SvgPicture.asset('assets/icons/ic_profile_edit.svg')),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                    child: SvgPicture.asset(
                        'assets/icons/ic_profile_setting.svg')),
              ],
            ),
            extendBodyBehindAppBar: true, //body 위에 appbar
            body: const Center(child: Text("로그인이 완료 된 사용자 프로필")))

        //토큰이 존재하지 않는 경우
        : const NotLoginWidget();
  }
}

//Center(child: Text("로그인이 완료 된 사용자 프로필"))
