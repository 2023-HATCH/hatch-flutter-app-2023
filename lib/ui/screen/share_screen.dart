import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/share_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/ui/loader/music_spinner_loader.dart';
import 'package:pocket_pose/ui/view/video/share_video_play_view.dart';
import 'package:pocket_pose/ui/widget/custom_simple_dialog_widget.dart';
import 'package:provider/provider.dart';

class ShareScreen extends StatefulWidget {
  final String videoUuid;
  const ShareScreen({Key? key, required this.videoUuid}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  late ShareProviderImpl _shareProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late VideoData _video;
  final int screenNum = 5;

  @override
  void initState() {
    super.initState();
    _shareProvider = Provider.of<ShareProviderImpl>(context, listen: false);
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
  }

  Future<bool> _initVideo() async {
    _video = await _shareProvider.getVideoDetail(widget.videoUuid);

    if (mounted) {
      _multiVideoPlayProvider.addVideo(screenNum, _video);
      _multiVideoPlayProvider.playVideo(screenNum);
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _multiVideoPlayProvider.resetVideoPlayer(screenNum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.transparent,
      ),
      extendBody: true,
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: FutureBuilder<bool>(
        future: _initVideo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const ShareVideoPlayeView();
          } else {
            return const MusicSpinner();
          }
        },
      ),
    );
  }
}
