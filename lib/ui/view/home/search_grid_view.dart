import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/ui/video_viewer/screen/profile_video_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/app_color.dart';
import '../../../data/entity/request/videos_request.dart';
import '../../../data/remote/provider/search_provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({
    super.key,
  });
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late SearchProvider _searchProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  void initState() {
    super.initState();
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
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
  void dispose() {
    super.dispose();

    _searchProvider.isGetRandomVideoSuccess = false;
    _searchProvider.randomVideosResponse = null;
    _multiVideoPlayProvider.resetVideoPlayer(3);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _initVideo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_searchProvider.randomVideosResponse != null) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      MediaQuery.of(context).size.height,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileVideoScreen(
                                    screenNum: 3, // 검색 페이지

                                    // 업로드 비디오 리스트 전송
                                    videoList: _searchProvider
                                        .randomVideosResponse!.videoList,
                                    // 처음에 열 페이지 전송
                                    initialIndex: index,
                                    onRefresh: () {
                                      setState(() {});
                                    },
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                              _searchProvider.randomVideosResponse!
                                  .videoList[index].thumbnailUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity, loadingBuilder:
                                  (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Shimmer.fromColors(
                              baseColor: const Color.fromRGBO(240, 240, 240, 1),
                              highlightColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromRGBO(240, 240, 240, 1)),
                              ),
                            );
                          }),
                          Positioned(
                            bottom: 8,
                            left: 8,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _searchProvider.randomVideosResponse!
                                      .videoList[index].viewCount
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount:
                    _searchProvider.randomVideosResponse!.videoList.length,
              );
            } else {
              //검색 로딩 인디케이터
              return CircularProgressIndicator(
                color: AppColor.purpleColor,
              );
            }
          } else {
//검색 로딩 인디케이터
            return CircularProgressIndicator(
              color: AppColor.purpleColor,
            );
          }
        });
  }
}
