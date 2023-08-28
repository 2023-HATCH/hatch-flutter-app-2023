import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/remote/provider/follow_provider.dart';
import 'package:pocket_pose/ui/view/profile/follow_user_list_view.dart';
import 'package:provider/provider.dart';

class FollowTabScreen extends StatefulWidget {
  const FollowTabScreen(
      {Key? key, required this.tapNum, required this.profileResponse})
      : super(key: key);

  final int tapNum;
  final ProfileResponse profileResponse;

  @override
  State<StatefulWidget> createState() => _FollowTabScreenState();
}

class _FollowTabScreenState extends State<FollowTabScreen>
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
          tabs: const [
            Tab(text: '팔로워'),
            Tab(text: ' 팔로잉'),
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
                        response.followerList.isEmpty
                            ? const Center(child: Text('팔로워한 사용자가 없습니다.'))
                            : FollowUserListView(
                                tabNum: 0,
                                followList: response.followerList,
                                profileResponse: widget.profileResponse,
                                initFollows: _initFollows,
                              ),
                        response.followingList.isEmpty
                            ? const Center(child: Text('팔로잉한 사용자가 없습니다.'))
                            : FollowUserListView(
                                tabNum: 1,
                                followList: response.followingList,
                                profileResponse: widget.profileResponse,
                                initFollows: _initFollows,
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
