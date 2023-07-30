// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:provider/provider.dart';

class VideoUserInfoFrame extends StatelessWidget {
  VideoUserInfoFrame({super.key, required this.index});

  late VideoPlayProvider _videoPlayProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    UserData user = _videoPlayProvider.videoList[index].user;
    VideoData video = _videoPlayProvider.videoList[index];

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
                        child: user.profileImg != null
                            ? Image.network(
                                user.profileImg!,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.fill,
                                width: 35,
                                height: 35,
                              )
                            : Image.asset(
                                'assets/images/app_logo.png', //추후에 포포 기본 이미지로 바꾸기
                                fit: BoxFit.fill,
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
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ]),
        ));
  }
}
