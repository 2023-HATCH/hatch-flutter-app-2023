import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/share_provider_impl.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/ui/view/video/share_video_play_view.dart';
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

  @override
  void initState() {
    _shareProvider = Provider.of<ShareProviderImpl>(context, listen: false);
    super.initState();
    _shareProvider = Provider.of<ShareProviderImpl>(context, listen: false);
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
  }

  Future<bool> _initVideo() async {
    _video = await _shareProvider.getVideoDetail(widget.videoUuid);

    if (mounted) {
      _multiVideoPlayProvider.addVideo(5, _video);
    }
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _multiVideoPlayProvider.resetVideoPlayer(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.blue,
      body: FutureBuilder<bool>(
        future: _initVideo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const ShareVideoPlayeView();
          } else {
            return Center(
              child: CircularProgressIndicator(color: AppColor.purpleColor),
            );
          }
        },
      ),
    );
  }
}
