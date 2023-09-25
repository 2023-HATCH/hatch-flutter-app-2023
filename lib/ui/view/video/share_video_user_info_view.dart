import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/ui/screen/profile/profile_screen.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';
import 'package:provider/provider.dart';

class ShareVideoUserInfoView extends StatefulWidget {
  const ShareVideoUserInfoView(
      {super.key, required this.screenNum, required this.index});

  final int screenNum;
  final int index;

  @override
  State<ShareVideoUserInfoView> createState() => _ShareVideoUserInfoViewState();
}

class _ShareVideoUserInfoViewState extends State<ShareVideoUserInfoView> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  Widget build(BuildContext context) {
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    UserData user =
        _multiVideoPlayProvider.videos[widget.screenNum][widget.index].user;
    VideoData video =
        _multiVideoPlayProvider.videos[widget.screenNum][widget.index];

    return Positioned(
        bottom: 40,
        left: 20,
        child: SizedBox(
          width: 270,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (_multiVideoPlayProvider.isOpenProfile == false) {
                      _multiVideoPlayProvider.isOpenProfile = true;

                      _multiVideoPlayProvider.pauseVideo(widget.screenNum);

                      PageRouteWithSlideAnimation pageRouteWithAnimation =
                          PageRouteWithSlideAnimation(
                              ProfileScreen(userId: user.userId));
                      Navigator.push(context,
                              pageRouteWithAnimation.slideLeftToRight())
                          .then((value) {
                        _multiVideoPlayProvider.isOpenProfile = false;
                        _multiVideoPlayProvider.playVideo(widget.screenNum);
                      });
                    } else {
                      Navigator.pop(context);
                    }
                    _multiVideoPlayProvider.pauseVideo(widget.screenNum);
                  },
                  child: Row(children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          user.profileImg ??
                              'assets/images/charactor_popo_default.png',
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
                    Text(
                      user.nickname,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ]),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 8)),
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: '${video.title}  ',
                      ),
                      TextSpan(
                        text: video.tag,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ]),
        ));
  }
}
