import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:pocket_pose/ui/video_viewer/screen/profile_video_screen.dart';
import 'package:shimmer/shimmer.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.videoList});

  final List<VideoData> videoList;
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
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
                          videoList: widget.videoList,
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
                Image.network(widget.videoList[index].thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(240, 240, 240, 1),
                    highlightColor: const Color.fromARGB(255, 255, 255, 255),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(240, 240, 240, 1)),
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
                        widget.videoList[index].viewCount.toString(),
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
      itemCount: widget.videoList.length,
    );
  }
}
