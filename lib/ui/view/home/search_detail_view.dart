import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/search_provider.dart';
import 'package:pocket_pose/ui/view/home/search_view.dart';
import 'package:pocket_pose/ui/view/home/user_list_view.dart';
import 'package:pocket_pose/ui/loader/user_list_loader.dart';
import 'package:provider/provider.dart';
import '../../screen/profile/follow_tab_screen.dart';

class SearchDetailView extends StatefulWidget {
  const SearchDetailView({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  State<StatefulWidget> createState() => _SearchDetailViewState();
}

class _SearchDetailViewState extends State<SearchDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SearchProvider _searchProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  int loading = 0;

  Future<bool> _initContent() async {
    if (mounted) {
      if (!_searchProvider.isVideoLoadingDone) {
        // 태그 검색 api 호출
        debugPrint(
            '1: 프로필 현재 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPages[4]}');

        _searchProvider
            .getTagSearch(
                widget.value,
                VideosRequest(
                    page: _multiVideoPlayProvider.currentPages[4], size: 100))
            .then((value) {
          final response = _searchProvider.tagVideosResponse;

          if (mounted) {
            if (response != null) {
              setState(() {
                if (response.videoList.isNotEmpty) {
                  _multiVideoPlayProvider.addVideos(4, response.videoList);
                }
                if (response.isLast) {
                  _multiVideoPlayProvider.isLasts[4] = true;
                  return;
                }
              });
            }
          }

          _multiVideoPlayProvider.currentPages[4]++;
          debugPrint(
              '1: 프로필 다음에 호출될 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPages[4]}');
        });

        // 유저 검색 api 호출
        await _searchProvider.getUserSearch(widget.value);

        _searchProvider.isVideoLoadingDone = true;
      }
    }

    return _searchProvider.tagVideosResponse != null &&
        _searchProvider.usersResponse != null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();

    _searchProvider.isVideoLoadingDone = false;

    _multiVideoPlayProvider.resetVideoPlayer(4);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          child: Column(children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: AppColor.grayColor3,
          indicatorColor: AppColor.purpleColor,
          tabs: const [
            Tab(text: '계정'),
            Tab(text: '태그'),
          ],
        ),
        FutureBuilder<bool>(
            future: _initContent(),
            builder: (context, snapshot) {
              debugPrint('검색: ${snapshot.connectionState}');
              if (snapshot.connectionState == ConnectionState.done) {
                loading++;
                if (loading >= 1) {
                  return Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: [
                      _searchProvider.usersResponse != null &&
                              _searchProvider.usersResponse!.isNotEmpty
                          ? UserListView(
                              userList: _searchProvider.usersResponse!)
                          : const Center(child: Text('검색된 결과가 없습니다.')),
                      _searchProvider.tagVideosResponse != null &&
                              _searchProvider
                                  .tagVideosResponse!.videoList.isNotEmpty
                          ? SearchView(
                              screenNum: 4,
                              videoList:
                                  _searchProvider.tagVideosResponse!.videoList)
                          :
                          // 태그 비디오 로딩 인디케이터
                          const Center(child: Text('검색된 결과가 없습니다.'))
                    ],
                  ));
                } else {
                  return const UserListLoader();
                }
              } else {
                return const UserListLoader();
              }
            }),
      ]))
    ]);
  }
}
