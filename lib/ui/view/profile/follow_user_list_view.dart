// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/remote/provider/follow_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/domain/entity/follow_data.dart';
import 'package:pocket_pose/ui/widget/custom_simple_dialog_widget.dart';
import 'package:provider/provider.dart';

class FollowUserListView extends StatefulWidget {
  const FollowUserListView({
    Key? key,
    required this.tabNum,
    required this.followList,
    required this.profileResponse,
    required this.initFollows,
  }) : super(key: key);

  final int tabNum;
  final List<FollowData> followList;
  final ProfileResponse profileResponse;
  final Future<bool> Function() initFollows;

  @override
  State<StatefulWidget> createState() => _FollowUserListViewState();
}

class _FollowUserListViewState extends State<FollowUserListView> {
  late FollowProvider _followProvider;
  late ProfileProvider _profileProvider;
  late List<bool> isFollowings =
      List<bool>.filled(widget.followList.length, true);

  @override
  void initState() {
    super.initState();
    _followProvider = Provider.of<FollowProvider>(context, listen: false);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // 프로필 화면 새로고침
    _profileProvider.getUserProfile(widget.profileResponse.user.userId);
    widget.initFollows();
  }

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
                      if (widget.followList[index].introduce != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(bottom: 8)),
                            Text(
                              widget.followList[index].introduce!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              widget.tabNum == 0 // : 팔로워 탭
                  ? Container()
                  : // tabNum == 1 : 팔로잉 탭
                  widget.profileResponse.profile.isMe
                      ? InkWell(
                          onTap: () async {
                            if (isFollowings[index]) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomSimpleDialog(
                                      title: '⛔ 팔로우 취소',
                                      message:
                                          '원하는 경우 ${widget.followList[index].user.nickname}님에게 팔로우를 다시 요청할 수 있습니다.',
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      onConfirm: () async {
                                        //팔로워 삭제 api 호출
                                        if (isFollowings[index]) {
                                          if (await _followProvider
                                              .deleteFollow(widget
                                                  .followList[index]
                                                  .user
                                                  .userId)) {
                                            setState(() {
                                              isFollowings[index] =
                                                  !isFollowings[index];
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: '다시 시도하세요.',
                                            );
                                          }
                                        }

                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            } else {
                              if (!isFollowings[index]) {
                                if (await _followProvider.postFollow(
                                    widget.followList[index].user.userId)) {
                                  setState(() {
                                    isFollowings[index] = !isFollowings[index];
                                  });
                                } else {
                                  Fluttertoast.showToast(msg: '다시 시도해주세요.');
                                }
                              }
                            }
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: isFollowings[index]
                                ? AppColor.grayColor1
                                : AppColor.blueColor1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                              child: Text(
                                isFollowings[index] ? '팔로잉' : '팔로우',
                                style: TextStyle(
                                    fontSize: 10, color: AppColor.grayColor),
                              ),
                            ),
                          ),
                        )
                      : Container()
            ],
          ),
        );
      },
    );
  }
}
