import 'package:flutter/material.dart';
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
        body: Center(
            child: TextButton(
                onPressed: () {
                  authProvider.kakaoSignOut();
                  Navigator.pop(context);
                },
                child: const Text("로그아웃"))));
  }
}
