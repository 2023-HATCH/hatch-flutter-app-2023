import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/ui/video_viewer/multi_video_player_view.dart';
import 'package:pocket_pose/ui/video_viewer/widget/comment_button_widget.dart';
import 'package:pocket_pose/ui/widget/profile/custom_simple_dialog.dart';
import 'package:provider/provider.dart';

class ProfileVideoScreen extends StatefulWidget {
  const ProfileVideoScreen(
      {Key? key,
      required this.isMe,
      required this.videoList,
      required this.initialIndex,
      required this.profileResponse})
      : super(key: key);

  final bool isMe;
  final List<VideoData> videoList;
  final int initialIndex;
  final ProfileResponse profileResponse;

  @override
  State<ProfileVideoScreen> createState() => _ProfileVideoScreenState();
}

class _ProfileVideoScreenState extends State<ProfileVideoScreen> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late VideoProvider _videoProvider;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _videoProvider = Provider.of<VideoProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _multiVideoPlayProvider.pauseVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            if (widget.isMe) // 본인 영상일때만 보이는 삭제 버튼
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
                            _videoProvider.deleteVideo(
                              _multiVideoPlayProvider
                                  .videoList[
                                      _multiVideoPlayProvider.currentIndex]
                                  .uuid,
                            );
                            Fluttertoast.showToast(
                              msg: '영상이 삭제되었습니다.',
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                            //프로필 영상 조회 api 호출
                          },
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
        extendBodyBehindAppBar: true, //body 위에 appbar
        resizeToAvoidBottomInset: false,
        body: const MultiVideoPlayerView(
            screenName:
                'my'), // 하나로 만들어야된다.. videoList(required)랑 initialIndex(nullable, null이면 0부터)를 인자로..
        bottomSheet: Container(
          height: 65,
          color: Colors.white,
          child: widget.isMe
              ? Row(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(left: 18)),
                    SvgPicture.asset(
                      'assets/icons/ic_profile_views.svg',
                      width: 20,
                      color: AppColor.purpleColor2,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 18)),
                    const Expanded(
                      child: Text(
                        '조회수 46회',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(left: 18)),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          widget.profileResponse.user.profileImg ??
                              'assets/images/charactor_popo_default.png',
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.purpleColor,
                              ),
                            );
                          },
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )),
                    const Padding(padding: EdgeInsets.only(left: 18)),
                    Expanded(
                      child: CommentButtonWidget(
                        index: widget.initialIndex,
                        onRefresh: () {
                          setState(() {});
                        },
                        videoId: widget.videoList[widget.initialIndex].uuid,
                        commentCount:
                            widget.videoList[widget.initialIndex].commentCount,
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
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
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
