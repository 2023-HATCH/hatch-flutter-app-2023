import 'dart:math';
import 'package:flutter/material.dart';

class NestedScrollViewExample extends StatefulWidget {
  static const String routeName = '/week_of_widget/nested_scroll_view';

  const NestedScrollViewExample({super.key});

  @override
  NestedScrollViewExampleState createState() => NestedScrollViewExampleState();
}

class NestedScrollViewExampleState extends State<NestedScrollViewExample> {
  final List<String> _videoImagePath = [
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_4",
    "profile_video_5",
    "profile_video_6",
    "profile_video_7",
    "profile_video_8",
    "profile_video_9",
    "profile_video_10",
    "profile_video_11",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_4",
    "profile_video_5",
    "profile_video_6",
    "profile_video_7",
    "profile_video_8",
    "profile_video_9",
    "profile_video_10",
    "profile_video_11",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_4",
    "profile_video_5",
    "profile_video_6",
    "profile_video_7",
    "profile_video_8",
    "profile_video_9",
    "profile_video_10",
    "profile_video_11",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_4",
    "profile_video_5",
    "profile_video_6",
    "profile_video_7",
    "profile_video_8",
    "profile_video_9",
    "profile_video_10",
    "profile_video_11",
  ];

  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 0);

  final double sliverMinHeight = 80.0, sliverMaxHeight = 140.0;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: headerSliverBuilder,
        body: Container(
          margin: EdgeInsets.only(top: sliverMinHeight),
          child: mainPageView(),
        ),
      ),
    ));
  }

  List<Widget> headerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegateCS(
            minHeight: sliverMinHeight,
            maxHeight: sliverMaxHeight,
            minChild: minTopChild(),
            maxChild: topChild(),
          ),
        ),
      ),
    ];
  }

  Widget minTopChild() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: const Color(0xFF014F90),
            child: const Text(
              "Min Top Bar",
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 23,
              ),
            ),
          ),
        ),
        pageButtonLayout(),
      ],
    );
  }

  Widget topChild() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: const Color(0xFFFF1D1D),
            child: const Text(
              "Max Top Bar",
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 23,
              ),
            ),
          ),
        ),
        pageButtonLayout(),
      ],
    );
  }

  Widget pageButtonLayout() {
    return SizedBox(
      height: sliverMinHeight / 2,
      child: Row(
        children: <Widget>[
          Expanded(child: pageButton("page 1", 0)),
          Expanded(child: pageButton("page 2", 1)),
          Expanded(child: pageButton("page 3", 2)),
          Expanded(child: pageButton("page 4", 3)),
        ],
      ),
    );
  }

  Widget pageButton(String title, int page) {
    final fontColor =
        pageIndex == page ? const Color(0xFF2C313C) : const Color(0xFF9E9E9E);
    final lineColor =
        pageIndex == page ? const Color(0xFF014F90) : const Color(0xFFF1F1F1);

    return InkWell(
      splashColor: const Color(0xFF204D7E),
      onTap: () => pageBtnOnTap(page),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: fontColor,
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: lineColor,
          ),
        ],
      ),
    );
  }

  pageBtnOnTap(int page) {
    setState(() {
      pageIndex = page;
      pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCirc);
    });
  }

  Widget mainPageView() {
    return PageView(
      controller: pageController,
      children: <Widget>[
        pageItem(
          Container(
            child: SliverAnimatedGrid(
              initialItemCount: _videoImagePath.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height),
              ),
              itemBuilder: (context, index, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      "assets/images/${_videoImagePath[index]}.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        pageItem(const Center(
          child: Text(
            "page 2\n\n두번재\n\n페이지\n\n스크롤이\n\n되도록\n\n내용을\n\n길게\n\n길게",
            style: TextStyle(fontSize: 50),
          ),
        )),
        pageItem(const Center(
          child: Text("page 3"),
        )),
        pageItem(const Center(
          child: Text("page 4"),
        )),
      ],
      onPageChanged: (index) => setState(() => pageIndex = index),
    );
  }

  Widget pageItem(Widget child) {
    double statusHeight = MediaQuery.of(context).padding.top;
    double height = MediaQuery.of(context).size.height;
    double minHeight = height - statusHeight - sliverMinHeight;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        constraints: BoxConstraints(minHeight: minHeight),
        child: child,
      ),
    );
  }
}

class SliverHeaderDelegateCS extends SliverPersistentHeaderDelegate {
  SliverHeaderDelegateCS({
    required this.minHeight,
    required this.maxHeight,
    required this.maxChild,
    required this.minChild,
  });
  final double minHeight, maxHeight;
  final Widget maxChild, minChild;

  late double visibleMainHeight, animationVal, width;

  @override
  bool shouldRebuild(SliverHeaderDelegateCS oldDelegate) => true;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  double scrollAnimationValue(double shrinkOffset) {
    double maxScrollAllowed = maxExtent - minExtent;

    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed)
        .clamp(0, 1)
        .toDouble();
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    width = MediaQuery.of(context).size.width;
    visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    animationVal = scrollAnimationValue(shrinkOffset);

    return Container(
        height: visibleMainHeight,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFFFFFFFF),
        child: Stack(
          children: <Widget>[
            getMinTop(),
            animationVal != 0 ? getMaxTop() : Container(),
          ],
        ));
  }

  Widget getMaxTop() {
    return Positioned(
      bottom: 0.0,
      child: Opacity(
        opacity: animationVal,
        child: SizedBox(
          height: maxHeight,
          width: width,
          child: maxChild,
        ),
      ),
    );
  }

  Widget getMinTop() {
    return Opacity(
      opacity: 1 - animationVal,
      child: SizedBox(height: visibleMainHeight, width: width, child: minChild),
    );
  }
}
