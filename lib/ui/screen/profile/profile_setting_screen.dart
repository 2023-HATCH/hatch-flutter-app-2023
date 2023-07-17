import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/auth_provider.dart';
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
        body: Center(
            child: TextButton(
                onPressed: () {
                  authProvider.kakaoSignOut();
                  Navigator.pop(context);
                },
                child: const Text("로그아웃"))));
  }
}
