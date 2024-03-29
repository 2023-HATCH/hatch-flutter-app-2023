// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/ui/view/video/multi_video_play_view.dart';
import 'package:pocket_pose/ui/view/home/comment_button_view.dart';
import 'package:pocket_pose/ui/loader/music_spinner_loader.dart';
import 'package:pocket_pose/ui/widget/custom_simple_dialog_widget.dart';
import 'package:provider/provider.dart';

class ProfileVideoScreen extends StatefulWidget {
  const ProfileVideoScreen(
      {Key? key,
      required this.screenNum,
      required this.videoList,
      required this.initialIndex,
      required this.onRefresh})
      : super(key: key);

  final int screenNum;
  final List<VideoData> videoList;
  final int initialIndex;
  final VoidCallback onRefresh;

  @override
  State<ProfileVideoScreen> createState() => _ProfileVideoScreenState();
}

class _ProfileVideoScreenState extends State<ProfileVideoScreen> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late VideoProvider _videoProvider;
  late KaKaoLoginProvider _loginProvider;
  late ProfileProvider _profileProvider;

  late UserData? _user;

  final TextEditingController _textController = TextEditingController();
  bool isMe = true;
  late int currentIndex = widget.initialIndex;

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _multiVideoPlayProvider.pauseVideo(widget.screenNum);
  }

  @override
  Widget build(BuildContext context) {
    _videoProvider = Provider.of<VideoProvider>(context, listen: false);
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: true);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 10) {
          Navigator.of(context).pop();
        }
      },
      child: FutureBuilder<bool>(
          future: _initUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                appBar: _appbar(context),
                extendBodyBehindAppBar: true,
                resizeToAvoidBottomInset: false,
                body: MultiVideoPlayerView(
                  screenNum: widget.screenNum,
                  initialIndex: currentIndex,
                  setCurrentIndex: setCurrentIndex,
                ),
                bottomSheet: _bottomSheet(),
              );
            } else {
              return const MusicSpinner();
            }
          }),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        child: const Text(
          "PoPo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          _multiVideoPlayProvider.pageControllers[widget.screenNum]
              .animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
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
        // 본인 영상일때만 보이는 삭제 버튼
        if (_user != null &&
            widget.videoList[currentIndex].user.userId == _user!.userId)
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
            child: GestureDetector(
              child: SvgPicture.asset('assets/icons/ic_profile_trash.svg'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return videoDeleteDialog(context);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  CustomSimpleDialog videoDeleteDialog(BuildContext context) {
    return CustomSimpleDialog(
      title: '⛔ 삭제',
      message: '영상을 삭제 하시겠습니까?',
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () async {
        // 영상 삭제
        if (await _videoProvider
            .deleteVideo(widget.videoList[currentIndex].uuid)) {
          // 프로필 업데이트
          _profileProvider.isVideoLoadingDone = false;
          _profileProvider.uploadVideosResponse = null;
          _profileProvider.likeVideosResponse = null;

          _multiVideoPlayProvider.resetVideoPlayer(1);
          _multiVideoPlayProvider.resetVideoPlayer(2);

          widget.onRefresh();
          Fluttertoast.showToast(
            msg: '영상이 삭제되었습니다.',
          );
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
            msg: '다시 시도하세요.',
          );
          Navigator.pop(context);
        }
      },
    );
  }

  Container _bottomSheet() {
    return Container(
      height: 65,
      color: Colors.black,
      child:
          // 본인 영상일 때는 조회수, 다른 사람 영상일 때는 댓글창이 뜨기
          _user != null &&
                  widget.videoList[currentIndex].user.userId == _user!.userId
              ? Row(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(left: 18)),
                    const Icon(
                      Icons.play_arrow_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 6)),
                    const Text(
                      '조회수',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 6)),
                    Expanded(
                      child: Text(
                        '${widget.videoList[currentIndex].viewCount.toString()}회',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(left: 18)),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: _user == null || _user!.profileImg == null
                            ? Image.asset(
                                'assets/images/charactor_popo_default.png',
                                width: 34,
                                height: 34,
                              )
                            : Image.network(
                                _user!.profileImg!,
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
                    Expanded(
                      child: CommentButtonView(
                        screenNum: widget.screenNum,
                        index: currentIndex,
                        onRefresh: () {},
                        videoId: widget.videoList[currentIndex].uuid,
                        commentCount:
                            widget.videoList[currentIndex].commentCount,
                        childWidget: const SizedBox(
                          height: 36,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(padding: EdgeInsets.only(left: 18)),
                              Expanded(
                                child: Text(
                                  '따듯한 말 한마디 남겨주세요   (❁´◡`❁)',
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
    );
  }

  Future<bool> _initUser() async {
    // 로그인한 사용자 정보 받아오기
    if (await _loginProvider.checkAccessToken()) {
      UserData user = await _loginProvider.getUser();

      _user = user;
    } else {
      _user = null;
    }

    return true;
  }

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
