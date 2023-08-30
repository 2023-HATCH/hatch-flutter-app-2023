import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/search_provider.dart';
import 'package:pocket_pose/ui/view/home/search_detail_view.dart';
import 'package:pocket_pose/ui/view/home/search_view.dart';
import 'package:provider/provider.dart';

import '../../widget/home/search_textfield_widget.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen>
    with SingleTickerProviderStateMixin {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late SearchProvider _searchProvider;

  bool _isSearched = false;
  String _value = "";

  void setScreen(bool isSearched, String value) {
    setState(() {
      _isSearched = isSearched;
      _value = value;
    });
  }

  Future<bool> _initVideo() async {
    if (mounted) {
      if (_searchProvider.isGetRandomVideoSuccess == null ||
          !_searchProvider.isGetRandomVideoSuccess!) {
        await _searchProvider
            .getRandomVideos(VideosRequest(
                page: _multiVideoPlayProvider.currentPages[3], size: 100))
            .then((value) {
          final response = _searchProvider.randomVideosResponse;

          if (response != null) {
            setState(() {
              if (response.videoList.isNotEmpty) {
                _multiVideoPlayProvider.addVideos(3, response.videoList);
              }
              if (response.isLast) {
                _multiVideoPlayProvider.isLasts[3] = true;
              }
            });
          }
        });
      }
      return true;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
    _multiVideoPlayProvider.pauseVideo(0);
  }

  @override
  void dispose() {
    super.dispose();

    _multiVideoPlayProvider.playVideo(0);
    _searchProvider.isGetRandomVideoSuccess = false;
    _searchProvider.isGetTagVideosSuccess = false;
    _searchProvider.randomVideosResponse = null;
    _searchProvider.tagVideosResponse = null;
    _multiVideoPlayProvider.resetVideoPlayer(3);
    _multiVideoPlayProvider.resetVideoPlayer(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '검색',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
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
        ),
        body: FutureBuilder<bool>(
            future: _initVideo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_searchProvider.randomVideosResponse != null) {
                  return Container(
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      SearchTextFieldWidget(setScreen: setScreen),
                      _isSearched
                          ? Flexible(
                              child: SearchDetailView(
                              value: _value,
                            ))
                          : Flexible(
                              child: SearchView(
                                  screenNum: 3,
                                  videoList: _searchProvider
                                      .randomVideosResponse!.videoList))
                    ]),
                  );
                } else {
                  return Container(color: Colors.white);
                }
              } else {
                return Container(color: Colors.white);
              }
            }));
  }
}
