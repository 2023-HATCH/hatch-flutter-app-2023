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
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.blue,
        body: Center(
          child: Text(
            "임시 공유화면\n video uuid: ${widget.videoUuid}",
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
