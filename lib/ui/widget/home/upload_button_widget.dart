// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/ui/screen/home/home_upload_screen.dart';
import 'package:provider/provider.dart';

class UploadButtonWidget extends StatefulWidget {
  const UploadButtonWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<UploadButtonWidget> createState() => _UploadButtonWidgetState();
}

class _UploadButtonWidgetState extends State<UploadButtonWidget> {
  late KaKaoLoginProvider _loginProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  void initState() {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);
    _loginProvider.mainContext = context;
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    File? videoFile;
    final picker = ImagePicker();

    Future getVideo(
      ImageSource img,
    ) async {
      final pickedFile = await picker.pickVideo(
          source: img,
          preferredCameraDevice: CameraDevice.front,
          maxDuration: const Duration(minutes: 10));
      XFile? xfilePick = pickedFile;
      setState(
        () {
          if (xfilePick != null) {
            videoFile = File(pickedFile!.path);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeUploadScreen(uploadFile: videoFile!)),
            );
          } else {
            _multiVideoPlayProvider.playVideo(0);

            ScaffoldMessenger.of(widget.context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    }

    _buildBottomSheet() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        backgroundColor: Colors.black,
        builder: (context) {
          return SizedBox(
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 23, 20, 8),
                  child: Text(
                    "만들기",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getVideo(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColor.grayColor,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/ic_home_upload_gallery.svg',
                            width: 16,
                            height: 16,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "갤러리에서 가져오기",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    _multiVideoPlayProvider.pauseVideo(0);
                    await Future.delayed(const Duration(
                        milliseconds: 200)); // 비디오 켤 때 버벅거림을 줄이기 위해 delay

                    getVideo(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColor.grayColor,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/ic_home_upload_camera.svg',
                            width: 16,
                            height: 16,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "직접 촬영하기",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: () async {
        if (await _loginProvider.checkAccessToken()) {
          _buildBottomSheet();
        } else {
          _loginProvider.showLoginBottomSheet();
        }
      },
      child: Container(
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset('assets/icons/ic_home_upload.svg')),
    );
  }
}
