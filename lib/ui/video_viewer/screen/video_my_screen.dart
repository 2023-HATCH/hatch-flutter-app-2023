import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/video_viewer/video_view.dart';
import 'package:pocket_pose/ui/widget/profile/custom_simple_dialog.dart';
import 'package:provider/provider.dart';

class VideoMyScreen extends StatefulWidget {
  VideoMyScreen({Key? key, required this.index}) : super(key: key);

  int index;

  @override
  State<VideoMyScreen> createState() => _VideoMyScreenState();
}

class _VideoMyScreenState extends State<VideoMyScreen> {
  late VideoPlayProvider _videoPlayProvider;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _videoPlayProvider.pauseVideo();
  }

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
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ic_stage_back_white.svg',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: GestureDetector(
                  child: SvgPicture.asset('assets/icons/ic_profile_trash.svg'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomSimpleDialog(
                              title: '⛔ 삭제',
                              message: '영상을 삭제 하시겠습니까?',
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () {
                                //영상 삭제 api 호출
                                Fluttertoast.showToast(
                                  msg: '영상이 삭제되었습니다.',
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                        });
                  })),
        ],
      ),
      extendBodyBehindAppBar: true, //body 위에 appbar
      resizeToAvoidBottomInset: false,
      body: const VideoView(screenName: 'my'),
      bottomSheet: Container(
        height: 65,
        color: Colors.black,
        child: Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(left: 18)),
            SvgPicture.asset(
              'assets/icons/ic_profile_views.svg',
              width: 20,
              color: AppColor.purpleColor,
            ),
            const Padding(padding: EdgeInsets.only(left: 18)),
            const Expanded(
              child: Text(
                '조회수 46회',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
