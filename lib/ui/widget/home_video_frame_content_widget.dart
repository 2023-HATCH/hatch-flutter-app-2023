// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../data/local/provider/video_play_provider.dart';

class VideoFrameContentWidget extends StatelessWidget {
  VideoFrameContentWidget({super.key, required this.index});

  late VideoPlayProvider _videoPlayProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return Container(
      //color: Colors.green,
      margin: const EdgeInsets.fromLTRB(20, 620, 100, 80),
      child: Column(children: <Widget>[
        GestureDetector(
          onTap: () {
            Fluttertoast.showToast(msg: 'user 클릭');
          },
          child: Row(children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child:
                    Image.asset(_videoPlayProvider.profiles[index], width: 35)),
            const Padding(padding: EdgeInsets.only(left: 8)),
            Text(
              _videoPlayProvider.nicknames[index],
              style: const TextStyle(color: Colors.white),
            ),
          ]),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        Text(
          _videoPlayProvider.contents[index],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ]),
    );
  }
}
