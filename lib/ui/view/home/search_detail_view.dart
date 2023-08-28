import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/search_provider.dart';
import 'package:pocket_pose/ui/view/home/search_view.dart';
import 'package:pocket_pose/ui/view/home/user_list_view.dart';
import 'package:provider/provider.dart';
import '../../screen/follow_tab_screen.dart';

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
    return FutureBuilder<bool>(
        future: _initContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: <Widget>[
              Flexible(
                child: Column(
                  children: [
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
                    Expanded(
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
                                  videoList: _searchProvider
                                      .tagVideosResponse!.videoList)
                              :
                              // 태그 비디오 로딩 인디케이터
                              const Center(child: Text('검색된 결과가 없습니다.'))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          } else {
            // 전체 화면 로딩 인디케이터
            return CircularProgressIndicator(
              color: AppColor.purpleColor,
            );
          }
        });
  }
}

// class FollowListViewWidget extends StatefulWidget {
//   FollowListViewWidget({
//     Key? key,
//     required this.tabNum,
//     required this.isfollows,
//     required this.profiles,
//     required this.nicknames,
//     required this.introduces,
//   }) : super(key: key);

//   int tabNum;
//   List<bool> isfollows;
//   List<String> profiles;
//   List<String> nicknames;
//   List<String> introduces;

//   @override
//   State<StatefulWidget> createState() => _FollowListViewWidgetState();
// }

// class _FollowListViewWidgetState extends State<FollowListViewWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.isfollows.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: Image.asset(
//                       widget.profiles[index],
//                       width: 35,
//                     ),
//                   ),
//                   const Padding(padding: EdgeInsets.only(left: 8)),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.nicknames[index],
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       if (widget.introduces[index].isNotEmpty)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Padding(padding: EdgeInsets.only(bottom: 8)),
//                             Text(
//                               widget.introduces[index],
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
