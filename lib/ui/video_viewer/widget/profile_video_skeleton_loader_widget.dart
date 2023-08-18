import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ProfileVideoSkeletonLoaderWidget extends StatelessWidget {
  const ProfileVideoSkeletonLoaderWidget({
    super.key,
    required int index,
    required TabController tabController,
  })  : _index = index,
        _tabController = tabController;

  final int _index;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, child) {
              final animation = _tabController.animation!;
              return ScaleTransition(
                scale: _index == 0
                    ? Tween<double>(begin: 1.0, end: 0.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOutQuart,
                        ),
                      )
                    : Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOutQuart,
                        ),
                      ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Shimmer.fromColors(
                        baseColor: const Color.fromRGBO(240, 240, 240, 1),
                        highlightColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromRGBO(240, 240, 240, 1)),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_profile_heart.svg',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '1.5k',
                              style: TextStyle(
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
          );
        },
        childCount: 6,
      ),
    );
  }
}
