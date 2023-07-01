import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/entity/response/stage_user_list_response.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/view/popo_play_view.dart';
import 'package:pocket_pose/ui/view/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/popo_result_view.dart';
import 'package:pocket_pose/ui/view/popo_wait_view.dart';
import 'package:provider/provider.dart';

final userListItem = {
  "list": [
    {
      "userId": "1",
      "profileImg": "assets/images/home_profile_1.jpg",
      "nickname": "나비"
    },
    {
      "userId": "2",
      "profileImg": "assets/images/home_profile_2.jpg",
      "nickname": "고양이"
    },
    {
      "userId": "3",
      "profileImg": "assets/images/home_profile_3.jpg",
      "nickname": "네코"
    },
    {
      "userId": "4",
      "profileImg": "assets/images/home_profile_4.jpg",
      "nickname": "냥코"
    },
    {
      "userId": "5",
      "profileImg": "assets/images/home_profile_5.jpg",
      "nickname": "멍멍이"
    },
    {
      "userId": "6",
      "profileImg": "assets/images/home_profile_1.jpg",
      "nickname": "강아지"
    },
    {
      "userId": "7",
      "profileImg": "assets/images/home_profile_2.jpg",
      "nickname": "개"
    },
    {
      "userId": "8",
      "profileImg": "assets/images/home_profile_3.jpg",
      "nickname": "포챠코"
    },
    {
      "userId": "9",
      "profileImg": "assets/images/home_profile_4.jpg",
      "nickname": "왕왕이"
    },
    {
      "userId": "10",
      "profileImg": "assets/images/home_profile_5.jpg",
      "nickname": "컹컹이"
    },
    {
      "userId": "11",
      "profileImg": "assets/images/home_profile_1.jpg",
      "nickname": "왈왈이"
    },
    {
      "userId": "12",
      "profileImg": "assets/images/home_profile_2.jpg",
      "nickname": "바둑이"
    },
    {
      "userId": "13",
      "profileImg": "assets/images/home_profile_3.jpg",
      "nickname": "마리"
    },
  ]
};
StageUserListResponse? userList;

enum StageStage { waitState, catchState, playState, resultState }

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen({super.key, required this.getIndex()});
  final Function getIndex;

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen>
    with TickerProviderStateMixin {
  int _userCount = 1;
  int _count = 1;
  late Timer _timer;
  late VideoPlayProvider _videoPlayProvider;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFieldFocusNode = FocusNode();
  bool _isFireIconVisible = true;

  List<Widget> selectWidgets = [];
  final List<AnimationController> _animationControllers = [];
  final List<Animation<Offset>> _animations = [];
  bool isLeft = true;

  StageStage _stageStage = StageStage.waitState;
  @override
  void initState() {
    super.initState();

    _startTimer();
    _inputFieldFocusNode.addListener(() {
      setState(() {
        _isFireIconVisible = (_inputFieldFocusNode.hasFocus) ? false : true;
      });
    });
  }

  @override
  void dispose() {
    AudioPlayerUtil().stop();
    if (widget.getIndex() == 0) {
      _videoPlayProvider.playVideo();
    }
    for (final animationController in _animationControllers) {
      animationController.dispose();
    }
    _textController.dispose();
    _inputFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              // 플레이, 결과 상태에 따라 배경화면 변경
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage((getIsResultState())
                      ? 'assets/images/bg_popo_result.png'
                      : 'assets/images/bg_popo_comm.png'),
                ),
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,
                appBar: buildAppBar(context),
                body: Stack(
                  children: [
                    _buildStageView(_stageStage),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildInputArea(context),
                    ),
                    ...selectWidgets,
                  ],
                ),
              )),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "PoPo 스테이지",
        style: TextStyle(fontSize: 18),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          AudioPlayerUtil().stop();
          if (widget.getIndex() == 0) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
        icon: SvgPicture.asset(
          'assets/icons/ic_stage_back_white.svg',
        ),
      ),
      actions: [
        _buildUserCountWidget(),
      ],
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_userCount == 3) {
        _stopTimer();

        if (mounted) {
          setState(() {
            _stageStage = StageStage.catchState;
          });
        }
      } else {
        setState(() {
          _count++;
          _userCount = _count + 1;
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void setStageState(StageStage newStageStage) {
    setState(() {
      _stageStage = newStageStage;
    });
  }

  bool getIsResultState() => _stageStage == StageStage.resultState;

  SafeArea _buildInputArea(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    padding: const EdgeInsets.only(left: 14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _textController,
                      cursorColor: Colors.white,
                      focusNode: _inputFieldFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'nickname(으)로 댓글 달기...',
                        hintStyle: TextStyle(color: Colors.white70),
                        labelStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isFireIconVisible ? 20 : 0,
                child: Visibility(
                  visible: _isFireIconVisible,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: _handleIconClick,
                    child: SvgPicture.asset(
                        'assets/icons/ic_popo_fire_unselect.svg'),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isFireIconVisible ? 14 : 0,
                child: Visibility(
                  visible: _isFireIconVisible,
                  child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: _handleIconClick,
                      child: const SizedBox(
                        width: 14,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildUserCountWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
      child: OutlinedButton.icon(
        onPressed: () {
          _showUserListDialog();
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          side: const BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        icon: SvgPicture.asset(
          'assets/icons/ic_users.svg',
        ),
        label: Text(
          '$_userCount',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<dynamic> _showUserListDialog() {
    userList = StageUserListResponse.fromJson(userListItem);

    return showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              backgroundColor: Colors.white.withOpacity(0.3),
              title: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '참여자 목록',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 265,
                height: 365,
                child: GridView.builder(
                  itemCount: userList!.list!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            userList!.list!.elementAt(index).profileImg!,
                            width: 58,
                            height: 58,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          userList!.list!.elementAt(index).nickname,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Widget _buildStageView(StageStage state) {
    switch (state) {
      case StageStage.waitState:
        return (_userCount < 3)
            ? const PoPoWaitView()
            : PoPoCatchView(setStageState: setStageState);
      case StageStage.catchState:
        return PoPoCatchView(setStageState: setStageState);
      case StageStage.playState:
        return PoPoPlayView(
            setStageState: setStageState, isResultState: getIsResultState());
      case StageStage.resultState:
        return PoPoResultView(
            setStageState: setStageState, isResultState: getIsResultState());
      default:
        return const PoPoWaitView();
    }
  }

  void _handleIconClick() {
    setState(() {
      isLeft = !isLeft;

      final animationController = AnimationController(
        duration: const Duration(milliseconds: 4000),
        vsync: this,
      );

      const beginOffset = Offset(0.0, 0.0);
      final middleOffset =
          isLeft ? const Offset(-8.0, -100.0) : const Offset(8.0, -100.0);
      const endOffset = Offset(0.0, -200.0);

      final animation = TweenSequence([
        TweenSequenceItem(
          tween: Tween<Offset>(begin: beginOffset, end: middleOffset),
          weight: 0.5,
        ),
        TweenSequenceItem(
          tween: Tween<Offset>(begin: middleOffset, end: endOffset),
          weight: 0.5,
        ),
      ]).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ));
      animationController.addListener(() {
        setState(() {});
      });

      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            selectWidgets.removeAt(0);
            _animationControllers.removeAt(0);
            _animations.removeAt(0);
          });
        }
      });

      selectWidgets.add(_buildSelectWidget(
        selectWidgets.length,
        animationController,
        animation,
      ));
      _animationControllers.add(animationController);
      _animations.add(animation);
    });

    _animationControllers.last.forward(from: 0);
  }

  Widget _buildSelectWidget(int index, AnimationController animationController,
      Animation<Offset> animation) {
    return Positioned(
      bottom: 14,
      right: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              animation.value.dx,
              animation.value.dy,
            ),
            child: FadeTransition(
              opacity: animationController.drive(Tween(begin: 1.0, end: 0.0)),
              child: child,
            ),
          );
        },
        child: Image.asset(
          'assets/icons/ic_popo_fire_select.png',
          height: 50,
        ),
      ),
    );
  }
}
