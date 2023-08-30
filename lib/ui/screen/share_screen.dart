import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  final String videoUuid;
  const ShareScreen({Key? key, required this.videoUuid}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        extendBody: true,
        backgroundColor: Colors.blue,
        body: Text(
          "임시 공유화면",
          style: TextStyle(color: Colors.white),
        ));
  }
}
