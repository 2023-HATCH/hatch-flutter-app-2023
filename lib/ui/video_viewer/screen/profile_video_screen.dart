import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/ui/video_viewer/multi_video_player_view.dart';
import 'package:pocket_pose/ui/video_viewer/widget/comment_button_widget.dart';
import 'package:pocket_pose/ui/widget/music_spinner_widget.dart';
import 'package:pocket_pose/ui/widget/profile/custom_simple_dialog.dart';
import 'package:provider/provider.dart';

class ProfileVideoScreen extends StatefulWidget {
  const ProfileVideoScreen(
      {Key? key,
      required this.screenNum,
      required this.videoList,
      required this.initialIndex,
      required this.profileResponse})
      : super(key: key);

  final int screenNum;
  final List<VideoData> videoList;
  final int initialIndex;
  final ProfileResponse profileResponse;

  @override
  State<ProfileVideoScreen> createState() => _ProfileVideoScreenState();
}

class _ProfileVideoScreenState extends State<ProfileVideoScreen> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late VideoProvider _videoProvider;
  late KaKaoLoginProvider _loginProvider;

  late UserData? _user;

  final TextEditingController _textController = TextEditingController();
  bool isMe = true;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _initUser() async {
    // 로그인한 사용자 정보 받아오기
    if (await _loginProvider.checkAccessToken()) {
      UserData user = await _loginProvider.getUser();

      _user = user;
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _multiVideoPlayProvider.pauseVideo(widget.screenNum);
  }

  @override
  Widget build(BuildContext context) {
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _videoProvider = Provider.of<VideoProvider>(context, listen: false);
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: true);

    return FutureBuilder<bool>(
        future: _initUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                  if (isMe) // 본인 영상일때만 보이는 삭제 버튼
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                      child: GestureDetector(
                        child: SvgPicture.asset(
                            'assets/icons/ic_profile_trash.svg'),
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
                                        .videos[widget.screenNum][
                                            _multiVideoPlayProvider
                                                    .currentIndexs[
                                                widget.screenNum]]
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
              body: MultiVideoPlayerView(
                  screenNum: widget.screenNum,
                  initialIndex: widget.initialIndex),

              bottomSheet: Container(
                height: 55,
                color: Colors.black,
                child: isMe
                    ? Row(
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(left: 18)),
                          SvgPicture.asset(
                            'assets/icons/ic_profile_views.svg',
                            width: 16,
                            color: Colors.grey,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 18)),
                          const Expanded(
                            child: Text(
                              '조회수 46회',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
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
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.purpleColor,
                                    ),
                                  );
                                },
                                width: 34,
                                height: 34,
                                fit: BoxFit.cover,
                              )),
                          //const Padding(padding: EdgeInsets.only(left: 18)),
                          Expanded(
                            child: CommentButtonWidget(
                              screenNum: widget.screenNum,
                              index: widget.initialIndex,
                              onRefresh: () {
                                setState(() {});
                              },
                              videoId:
                                  widget.videoList[widget.initialIndex].uuid,
                              commentCount: widget
                                  .videoList[widget.initialIndex].commentCount,
                              childWidget: const SizedBox(
                                height: 36,
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(30),
                                //   border: Border.all(color: AppColor.grayColor2),
                                // ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 18)),
                                    Expanded(
                                      child: Text(
                                        '따듯한 말 한마디 남겨주세요!',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
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
              ),
            );
          } else {
            return const MusicSpinner();
          }
        });
  }
}
