import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/auth_provider.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';
import 'package:pocket_pose/ui/widget/profile/custom_simple_dialog.dart';
import 'package:provider/provider.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정 및 개인정보',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/ic_back.png',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 2.0,
            color: AppColor.purpleColor,
          ),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                      'assets/icons/ic_profile_setting_privacy_greement.svg'),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 0, 18, 0)),
                  const Text(
                    '개인정보 동의서',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Image.asset('assets/icons/ic_profile_setting_next.png'),
            ],
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/ic_profile_setting_logout.svg'),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 18, 0)),
                const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          onTap: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomSimpleDialog(
                    title: '⚠️ 로그아웃',
                    message: '정말 로그아웃 하시겠습니까?',
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onConfirm: () {
                      Fluttertoast.showToast(
                        msg: '성공적으로 로그아웃 되었습니다.',
                      );
                      authProvider.kakaoSignOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                        (route) => false,
                      );
                    },
                  );
                })
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
          child: Row(
            children: [
              SvgPicture.asset(
                  'assets/icons/ic_profile_setting_withdrawal.svg'),
              const Padding(padding: EdgeInsets.fromLTRB(0, 0, 18, 0)),
              const Text(
                '회원탈퇴',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
