import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/widget/upload/custom_tag_text_field_controller.dart';
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
  late CustomTagTextFieldController _tagController;
  bool _isTitleFillOut = false;
  bool _isTagsFillOut = false;

  @override
  void initState() {
    _videoPlayProvider = Provider.of(context, listen: false);
    _videoPlayProvider.pauseVideo();
    _tagController = CustomTagTextFieldController(setIsTagsFillPutState);

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayProvider.playVideo();
    _videoPlayerController?.dispose();
    _tagController.dispose();
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
        child: Stack(
          children: [
            Container(
              color: Colors.purple,
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 134),
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

  Widget _buildVideoInfoArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 7),
            child: Row(
              children: [
                Text(
                  "제목",
                  style: TextStyle(fontSize: 14, color: AppColor.blackColor),
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
                        color: AppColor.grayColor2,
                        width: 2.5,
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _isTitleFillOut = value.isNotEmpty;
                        });
                      },
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      controller: _titleTextController,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: '포포와 함께 댄스 파티',
                        hintStyle: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 7, 18, 20),
            child: Row(
              children: [
                Text(
                  "태그",
                  style: TextStyle(fontSize: 14, color: AppColor.blackColor),
                ),
                const SizedBox(
                  width: 18,
                ),
                UploadTagTextFieldWidget(
                  tagController: _tagController,
                  setIsTagsFillPutState: setIsTagsFillPutState,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  setIsTagsFillPutState(bool state) {
    setState(() {
      _isTagsFillOut = state;
    });
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
          onPressed: () {
            // var title = _titleTextController.value.text;
            // var tags = _tagController.getTags;
          },
          child: Text(
            "업로드",
            style: TextStyle(
                color: (_isTitleFillOut && _isTagsFillOut)
                    ? AppColor.blueColor5
                    : AppColor.blueColor4,
                fontSize: 14),
          ),
        )
      ],
    );
  }
}
