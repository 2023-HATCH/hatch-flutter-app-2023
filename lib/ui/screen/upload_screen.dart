import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/video_upload_request.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/video_upload_provider_impl.dart';
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
  final _provider = VideoUploadProviderImpl();
  bool _isTitleFillOut = false;
  bool _isTagsFillOut = false;
  bool _isLoading = false;

  @override
  void initState() {
    _videoPlayProvider = Provider.of(context, listen: false);
    _videoPlayProvider.pauseVideo();
    _tagController = CustomTagTextFieldController(setIsTagsFillPutState);
    _initVideoPlayer();

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

  void postVideo(VideoUploadRequest request) async {
    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();

    await _provider.postVideoUpload(request).then((value) {
      if (value.code == 'VIDEO-2001') {
        Fluttertoast.showToast(msg: '영상이 성공적으로 업로드 되었습니다.');
        _isLoading = false;
        Navigator.pop(context);
      }
    });
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
              color: AppColor.purpleColor,
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: VideoPlayer(_videoPlayerController!),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _buildVideoInfoArea(),
            ),
            Visibility(
              visible: _isLoading,
              child: const ModalBarrier(
                color: Colors.black54,
                dismissible: false,
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: const Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                right: 0,
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(child: CircularProgressIndicator())),
              ),
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black,
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 7),
                child: Row(
                  children: [
                    const Text(
                      "제목",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 0, 0, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _isTitleFillOut = value.isNotEmpty;
                            });
                          },
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          controller: _titleTextController,
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            hintText: '포포와 함께 댄스 파티',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                            labelStyle: TextStyle(color: Colors.white),
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
                      style: TextStyle(fontSize: 14, color: Colors.white),
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
            ],
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
            if (_isTitleFillOut && _isTagsFillOut) {
              var title = _titleTextController.value.text;
              var tags = _tagController.getTags!;
              var tagsString = tags.map((tag) => '%23$tag').toList().join(' ');
              if (_isLoading == false) {
                postVideo(VideoUploadRequest(
                    title: title,
                    tags: tagsString,
                    videoPath: widget.uploadFile.path));
              } else {
                Fluttertoast.showToast(msg: '영상을 업로드 중입니다.');
              }
            }
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
