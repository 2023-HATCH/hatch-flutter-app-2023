import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/domain/entity/search_user_data.dart';
import 'package:pocket_pose/ui/screen/profile/profile_screen.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';

class UserListView extends StatefulWidget {
  const UserListView(
      {Key? key, required this.userList, required this.multiVideoPlayProvider})
      : super(key: key);

  final List<SearchUserData> userList;
  final MultiVideoPlayProvider multiVideoPlayProvider;

  @override
  State<StatefulWidget> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.userList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
          child: GestureDetector(
            onTap: () {
              PageRouteWithSlideAnimation pageRouteWithAnimation =
                  PageRouteWithSlideAnimation(ProfileScreen(
                      userId: widget.userList[index].user.userId));
              Navigator.push(
                  context, pageRouteWithAnimation.slideLeftToRight());
            },
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
                          widget.userList[index].user.profileImg!,
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
                          widget.userList[index].user.nickname,
                          style: const TextStyle(fontSize: 12),
                        ),
                        //자기소개
                        if (widget.userList[index].introduce != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 8)),
                              Text(
                                widget.userList[index].introduce!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
