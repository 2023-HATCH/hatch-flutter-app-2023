import 'package:flutter/material.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/screen/popo_catch_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PoPoWaitScreen extends StatelessWidget {
  PoPoWaitScreen({super.key});
  late VideoPlayProvider _videoPlayProvider;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/bg_popo_comm.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _videoPlayProvider.playVideo();
                },
                icon: const Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const PoPoCatchScreen()));
                },
                icon: const Icon(Icons.navigate_next_rounded))
          ],
        ),
        body: const Text(
          "대기",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
