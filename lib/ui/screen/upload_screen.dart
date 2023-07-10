import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.uploadFile});
  final File uploadFile;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(widget.uploadFile);
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.purple,
              height: 3,
            ),
            Expanded(
              child: FutureBuilder(
                future: _initVideoPlayer(),
                builder: (context, state) {
                  if (state.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return VideoPlayer(_videoPlayerController);
                  }
                },
              ),
            ),
            _buildVideoInfoArea(),
          ],
        ),
      ),
    );
  }

  Column _buildVideoInfoArea() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 7),
          child: Row(
            children: [
              const Text(
                "제목",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.5,
                    ),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    controller: _titleController,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      hintText: '포포와 함께 댄스 파티',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 7, 18, 20),
          child: Row(
            children: [
              const Text(
                "태그",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.5,
                    ),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    controller: _tagController,
                    cursorColor: Colors.grey,
                    decoration: const InputDecoration(
                      hintText: '#포포 #댄스챌린지',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "미리보기",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          "취소",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "업로드",
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        )
      ],
    );
  }
}
