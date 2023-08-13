// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class VideoUserInfoFrame extends StatelessWidget {
  VideoUserInfoFrame({super.key, required this.index});

  late MultiVideoPlayProvider _multiVideoPlayProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    UserData user = _multiVideoPlayProvider.videoList[index].user;
    VideoData video = _multiVideoPlayProvider.videoList[index];

    return Positioned(
        bottom: 110,
        left: 20,
        child: SizedBox(
          //color: Colors.green,
          width: 300,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: 'user 클릭');
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
