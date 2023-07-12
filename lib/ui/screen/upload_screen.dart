import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/widget/upload/upload_tag_text_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.uploadFile});
  final File uploadFile;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  VideoPlayerController? _videoPlayerController;
  late VideoPlayProvider _videoPlayProvider;

  @override
  void initState() {
    _videoPlayProvider = Provider.of(context, listen: false);
    _videoPlayProvider.pauseVideo();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayProvider.playVideo();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    if (_videoPlayerController == null) {
      _videoPlayerController = VideoPlayerController.file(widget.uploadFile);
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      await _videoPlayerController!.play();
    }
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
                    return VideoPlayer(_videoPlayerController!);
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _buildVideoInfoArea(),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildVideoInfoArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    controller: _titleTextController,
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
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 7, 18, 20),
          child: Row(
            children: [
              Text(
                "태그",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(
                width: 18,
              ),
              UploadTagTextFieldWidget(),
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
