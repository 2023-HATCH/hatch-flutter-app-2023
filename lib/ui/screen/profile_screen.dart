import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
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
        ? const Center(child: Text("로그인이 완료 된 사용자 프로필"))
        //토큰이 존재하지 않는 경우
        : const NotLoginWidget();
  }
}
