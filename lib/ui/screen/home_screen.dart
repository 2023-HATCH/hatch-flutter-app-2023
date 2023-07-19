import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/ui/video_viewer/video_view.dart';
import 'package:pocket_pose/ui/widget/home/upload_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //centerTitle: true, //Title text 가운데 정렬
          title: const Text(
            "PoPo",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent, //appBar 투명색
          elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
          actions: [
            UploadButtonWidget(context: context),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                child: SvgPicture.asset('assets/icons/ic_home_search.svg')),
          ],
        ),
        extendBodyBehindAppBar: true, //body 위에 appbar
        resizeToAvoidBottomInset: false,
        body: const VideoView());
  }
}
