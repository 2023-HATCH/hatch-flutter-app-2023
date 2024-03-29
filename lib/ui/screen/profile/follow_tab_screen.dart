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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 10) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: _appbar(context),
        body: _body(),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.profileResponse.user.nickname,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColor.purpleColor,
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
    );
  }

  FutureBuilder<bool> _body() {
    return FutureBuilder<bool>(
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
                : Container(color: Colors.white);
          } else {
            return Container(color: Colors.white);
          }
        });
  }

  Future<bool> _initFollows() {
    return _followProvider.getFollows(widget.profileResponse.user.userId);
  }
}
