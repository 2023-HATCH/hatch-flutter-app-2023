import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/video_viewer/video_view.dart';
import 'package:pocket_pose/ui/video_viewer/widget/comment_button_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class VideoSomeoneScreen extends StatefulWidget {
  VideoSomeoneScreen({Key? key, required this.index}) : super(key: key);

  int index;

  @override
  State<VideoSomeoneScreen> createState() => _VideoSomeoneScreenState();
}

class _VideoSomeoneScreenState extends State<VideoSomeoneScreen> {
  late VideoPlayProvider _videoPlayProvider;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
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
    UserData user = _videoPlayProvider.videoList[widget.index].user;
    final video = _videoPlayProvider.videoList[widget.index];

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
        ),
        extendBodyBehindAppBar: true, //body 위에 appbar
        resizeToAvoidBottomInset: false,
        body: const VideoView(screenName: 'someone'),
        bottomSheet: Container(
          height: 65,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(left: 18)),
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: user.profileImg != null
                      ? Image.asset(
                          user.profileImg!,
                          width: 40,
                        )
                      : Image.asset(
                          'assets/images/app_logo.png', //추후에 포포 기본 이미지로 변경
                          width: 40,
                        )),
              const Padding(padding: EdgeInsets.only(left: 18)),
              Expanded(
                child: CommentButtonWidget(
                  index: widget.index,
                  onRefresh: () {
                    setState(() {});
                  },
                  videoId: video.uuid,
                  commentCount: video.commentCount,
                  childWidget: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColor.grayColor2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 18)),
                        Expanded(
                          child: Text(
                            '따듯한 말 한마디 해주세요!',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 18)),
            ],
          ),
        ));
  }
}
