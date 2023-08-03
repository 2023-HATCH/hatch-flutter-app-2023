import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/ui/screen/home/home_upload_screen.dart';

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
            ScaffoldMessenger.of(widget.context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    }

    return InkWell(
      onTap: () => {
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
                    onTap: () {
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
        ),
      },
      borderRadius: const BorderRadius.all(
        Radius.circular(90.0),
      ),
      child: Container(
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset('assets/icons/ic_home_upload.svg')),
    );
  }
}
