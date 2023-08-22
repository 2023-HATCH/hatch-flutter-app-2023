import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/remote/provider/follow_provider.dart';
import 'package:pocket_pose/domain/entity/follow_data.dart';
import 'package:pocket_pose/ui/widget/profile/custom_simple_dialog.dart';
import 'package:provider/provider.dart';

class ProfileFollowScreen extends StatefulWidget {
  const ProfileFollowScreen(
      {Key? key, required this.tapNum, required this.profileResponse})
      : super(key: key);

  final int tapNum;
  final ProfileResponse profileResponse;

  @override
  State<StatefulWidget> createState() => _ProfileFollowScreenState();
}

class _ProfileFollowScreenState extends State<ProfileFollowScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FollowProvider _followProvider;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.tapNum);
    _followProvider = Provider.of<FollowProvider>(context, listen: false);
  }

  Future<bool> _initFollows() {
    return _followProvider.getFollows(widget.profileResponse.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.profileResponse.user.nickname,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
          tabs: [
            Tab(text: '${widget.profileResponse.profile.followerCount}  팔로워'),
            Tab(text: '${widget.profileResponse.profile.followingCount}  팔로잉'),
          ],
        ),
      ),
      body: FutureBuilder<bool>(
          future: _initFollows(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final response = _followProvider.response;
              return response != null
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        FollowListViewWidget(
                            tabNum: 0, followList: response.followerList),
                        FollowListViewWidget(
                          tabNum: 1,
                          followList: response.followingList,
                        ),
                      ],
                    )
                  :
                  // 프로필 목록 로딩 인디케이터
                  Center(
                      child: CircularProgressIndicator(
                        color: AppColor.purpleColor,
                      ),
                    );
            } else {
              // 프로필 목록 로딩 인디케이터
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.purpleColor,
                ),
              );
            }
          }),
    );
  }
}

class FollowListViewWidget extends StatefulWidget {
  const FollowListViewWidget({
    Key? key,
    required this.tabNum,
    required this.followList,
  }) : super(key: key);

  final int tabNum;
  final List<FollowData> followList;

  @override
  State<StatefulWidget> createState() => _FollowListViewWidgetState();
}

class _FollowListViewWidgetState extends State<FollowListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.followList.length,
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
                      child: Image.network(
                        widget.followList[index].user.profileImg!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColor.purpleColor,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/charactor_popo_default.png',
                          fit: BoxFit.cover,
                          width: 35,
                          height: 35,
                        ),
                        fit: BoxFit.cover,
                        width: 35,
                        height: 35,
                      )),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.followList[index].user.nickname,
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (widget.followList[index].introduce.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(bottom: 8)),
                            Text(
                              widget.followList[index].introduce,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              widget.tabNum == 0 //팔로워일 경우
                  ? widget.followList[index].isFollowing
                      ? InkWell(
                          onTap: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomSimpleDialog(
                                    title: '팔로워를 삭제하시겠어요?',
                                    message:
                                        '${widget.followList[index].user.nickname}님은 회원님의 팔로워 리스트에서 삭제된 사실을 알 수 없습니다.',
                                    onCancel: () {
                                      Navigator.pop(context);
                                    },
                                    onConfirm: () {
                                      Fluttertoast.showToast(
                                        msg: '삭제 되었습니다.',
                                      );
                                      //팔로워 삭제 api 호출
                                      setState(() {
                                        widget.followList[index].isFollowing =
                                            !widget
                                                .followList[index].isFollowing;
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                })
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: widget.followList[index].isFollowing
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
                          widget.followList[index].isFollowing =
                              !widget.followList[index].isFollowing;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.followList[index].isFollowing
                            ? AppColor.grayColor1
                            : AppColor.blueColor1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          child: Text(
                            widget.followList[index].isFollowing
                                ? '팔로잉'
                                : '팔로우',
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
