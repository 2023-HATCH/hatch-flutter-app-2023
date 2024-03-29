import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';
import 'package:pocket_pose/ui/screen/profile/profile_screen.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';

class ChatDetailLeftBubbleWidget extends StatelessWidget {
  final ChatDetailListItem chatDetail;
  final bool profileVisiblity;
  final bool headerVisiblity;

  const ChatDetailLeftBubbleWidget(
      {super.key,
      required this.chatDetail,
      required this.profileVisiblity,
      required this.headerVisiblity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, profileVisiblity ? 7 : 3, 24, profileVisiblity ? 3 : 7),
      child: Column(
        children: [
          _buildDateHeader(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildUserProfileAndBubble(context, profileVisiblity),
              const SizedBox(width: 8),
              _buildTimeStamp(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileAndBubble(
      BuildContext context, bool profileVisiblity) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileVisiblity
              ? InkWell(
                  onTap: () {
                    PageRouteWithSlideAnimation pageRouteWithAnimation =
                        PageRouteWithSlideAnimation(
                            ProfileScreen(userId: chatDetail.sender.userId));
                    Navigator.push(
                        context, pageRouteWithAnimation.slideRitghtToLeft());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: (chatDetail.sender.profileImg == null)
                        ? Image.asset(
                            'assets/images/charactor_popo_default.png',
                            width: 45,
                            height: 45,
                          )
                        : Image.network(
                            chatDetail.sender.profileImg!,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
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
                            ),
                          ),
                  ),
                )
              : const SizedBox(
                  width: 45,
                ),
          const SizedBox(
            width: 14,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                top: profileVisiblity ? 8 : 0.0,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  chatDetail.content,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeStamp() {
    return Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          _refomatTimeStamp(chatDetail.createdAt),
          style: TextStyle(
              fontSize: 10,
              color: AppColor.blackColor,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Visibility(
        visible: headerVisiblity,
        child: Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColor.grayColor6,
                thickness: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _refomatDate(chatDetail.createdAt),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Divider(
                color: AppColor.grayColor6,
                thickness: 0.5,
              ),
            ),
          ],
        ));
  }

  String _refomatTimeStamp(String timeStamp) {
    var temp = timeStamp.split(' ');
    temp = temp[1].split(':');
    var ampm = int.parse(temp[0]) < 12 ? "오전" : "오후";
    var hourTemp = (int.parse(temp[0].toString()) - 12 == 0)
        ? 12
        : int.parse(temp[0].toString()) - 12;
    var hour = (ampm == "오후") ? hourTemp : temp[0];
    return "$ampm $hour:${temp[1]}";
  }

  String _refomatDate(String date) {
    var temp = date.split(' ');
    temp = temp[0].split('/');
    return "${temp[0]}년 ${temp[1]}월 ${temp[2]}일";
  }
}
