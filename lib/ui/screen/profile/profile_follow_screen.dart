import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/ui/widget/profile/custom_simple_dialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileFollowScreen extends StatefulWidget {
  ProfileFollowScreen({Key? key, required this.tapNum, required this.index})
      : super(key: key);

  int tapNum;
  final int index;

  @override
  State<StatefulWidget> createState() => _ProfileFollowScreenState();
}

class _ProfileFollowScreenState extends State<ProfileFollowScreen>
    with SingleTickerProviderStateMixin {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late TabController _tabController;

  List<String> followingProfileList = [
    'assets/images/chat_user_1.png',
    'assets/images/chat_user_2.png',
    'assets/images/chat_user_3.png',
    'assets/images/chat_user_4.png',
    'assets/images/chat_user_5.png',
    'assets/images/chat_user_6.png',
  ];

  List<String> followingNicknameList = [
    'hello_kiti',
    'pochako',
    'pom_pom_pulin',
    'kelo_kelo_kelopi',
    'kogimyung_',
    'teogsido_saem'
  ];

  List<String> followingIntroduceList = [
    '안녕 난 키티야',
    '',
    '푸루루루푸우린',
    '케로로 아님',
    '',
    ''
  ];

  List<bool> followingList = [
    true,
    true,
    false,
    true,
    true,
    true,
  ];

  List<String> followerProfileList = [
    'assets/images/chat_user_4.png',
    'assets/images/chat_user_5.png',
    'assets/images/chat_user_6.png',
  ];

  List<String> followerNicknameList = [
    'kelo_kelo_kelopi',
    'kogimyung_',
    'teogsido_saem'
  ];

  List<String> followerIntroduceList = ['케로로 아님', '', ''];

  List<bool> followerList = [
    false,
    true,
    true,
  ];

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.tapNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '_multiVideoPlayProvider.videoList[widget.index].user.nickname',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/ic_back.png',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: AppColor.grayColor3,
          indicatorColor: AppColor.purpleColor,
          tabs: const [
            Tab(text: '106  팔로워'),
            Tab(text: '48.4k  팔로잉'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FollowListViewWidget(
              tabNum: 0,
              isfollows: followerList,
              profiles: followerProfileList,
              nicknames: followerNicknameList,
              introduces: followerIntroduceList),
          FollowListViewWidget(
              tabNum: 1,
              isfollows: followingList,
              profiles: followingProfileList,
              nicknames: followingNicknameList,
              introduces: followingIntroduceList),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FollowListViewWidget extends StatefulWidget {
  FollowListViewWidget({
    Key? key,
    required this.tabNum,
    required this.isfollows,
    required this.profiles,
    required this.nicknames,
    required this.introduces,
  }) : super(key: key);

  int tabNum;
  List<bool> isfollows;
  List<String> profiles;
  List<String> nicknames;
  List<String> introduces;

  @override
  State<StatefulWidget> createState() => _FollowListViewWidgetState();
}

class _FollowListViewWidgetState extends State<FollowListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.isfollows.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      widget.profiles[index],
                      width: 35,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nicknames[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (widget.introduces[index].isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(bottom: 8)),
                            Text(
                              widget.introduces[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              widget.tabNum == 0 //팔로워일 경우
                  ? widget.isfollows[index]
                      ? InkWell(
                          onTap: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomSimpleDialog(
                                    title: '팔로워를 삭제하시겠어요?',
                                    message:
                                        '${widget.nicknames[index]}님은 회원님의 팔로워 리스트에서 삭제된 사실을 알 수 없습니다.',
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                    onConfirm: () {
                                      Fluttertoast.showToast(
                                        msg: '삭제 되었습니다.',
                                      );
                                      //팔로워 삭제 api 호출
                                      setState(() {
                                        widget.isfollows[index] =
                                            !widget.isfollows[index];
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                })
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: widget.isfollows[index]
                                ? AppColor.grayColor1
                                : AppColor.blueColor1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                              child: Text(
                                '삭제',
                                style: TextStyle(
                                    fontSize: 10, color: AppColor.grayColor),
                              ),
                            ),
                          ),
                        )
                      : Container()
                  : //팔로우일 경우
                  InkWell(
                      onTap: () {
                        setState(() {
                          widget.isfollows[index] = !widget.isfollows[index];
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.isfollows[index]
                            ? AppColor.grayColor1
                            : AppColor.blueColor1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          child: Text(
                            widget.isfollows[index] ? '팔로잉' : '팔로우',
                            style: TextStyle(
                                fontSize: 10, color: AppColor.grayColor),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}
