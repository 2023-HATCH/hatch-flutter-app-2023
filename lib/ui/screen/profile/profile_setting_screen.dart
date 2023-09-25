import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';
import 'package:pocket_pose/ui/widget/custom_simple_dialog_widget.dart';
import 'package:provider/provider.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late KaKaoLoginProvider _loginProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context);
    _multiVideoPlayProvider = Provider.of<MultiVideoPlayProvider>(context);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 10) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: _appbar(context),
        body: _body(context),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: const Text(
        '설정 및 개인정보',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColor.purpleColor,
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
    );
  }

  Column _body(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      _row("privacy_greement", "개인정보 동의서", null),
      _row("logout", "로그아웃", showLogoutDialog),
      _row("withdrawal", "회원탈퇴", null)
    ]);
  }

  InkWell _row(String image, String title, Function? ontap) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/ic_profile_setting_$image.svg'),
            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 18, 0)),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      onTap: () => {
        if (ontap != null) {ontap()}
      },
    );
  }

  Future<dynamic> showLogoutDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomSimpleDialog(
            title: '⚠️ 로그아웃',
            message: '정말 로그아웃 하시겠습니까?',
            onCancel: () {
              Navigator.pop(context);
            },
            onConfirm: () {
              _loginProvider.signOut();

              _multiVideoPlayProvider.resetVideoPlayer(0);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            },
          );
        });
  }
}
