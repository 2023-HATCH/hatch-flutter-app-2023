import 'package:flutter/material.dart';
import 'package:pocket_pose/ui/screen/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.lightBlue, body: LoginScreen());
  }
}
