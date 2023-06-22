import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';

class GridTabBarWidget extends StatefulWidget {
  const GridTabBarWidget({Key? key}) : super(key: key);

  @override
  _GridTabBarWidgetState createState() => _GridTabBarWidgetState();
}

class _GridTabBarWidgetState extends State<GridTabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Color selectedLineColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedLineColor = AppColor.purpleColor; // 선택된 탭의 줄 색상
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: _tabController.index == 0
                  ? SvgPicture.asset('assets/icons/ic_profile_list_select.svg')
                  : SvgPicture.asset(
                      'assets/icons/ic_profile_list_unselect.svg'),
            ),
            Tab(
              icon: _tabController.index == 1
                  ? SvgPicture.asset('assets/icons/ic_profile_heart_select.svg')
                  : SvgPicture.asset(
                      'assets/icons/ic_profile_heart_unselect.svg'),
            ),
          ],
          unselectedLabelColor: Colors.black, // 선택되지 않은 탭의 텍스트 색상
          labelColor: AppColor.purpleColor, // 선택된 탭의 텍스트 색상
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColor.purpleColor, // 선택된 탭의 줄 색상
                width: 2.0, // 선택된 탭의 줄 두께
              ),
            ),
          ),
          onTap: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
        ),
        SizedBox(
          height: 700,
          child: TabBarView(
            controller: _tabController,
            children: [
              // GridView.builder(
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 3,
              //   ),
              //   itemBuilder: (context, index) {
              //     return Center(
              //       child: Text(
              //         'Tab 1 - Item $index',
              //       ),
              //     );
              //   },
              //   itemCount: 100,
              // ),
              GridView.count(
                crossAxisCount: 3,
                children: List.generate(100, (index) {
                  return Center(
                    child: Text(
                      'Tab 1 - Item $index',
                    ),
                  );
                }),
              ),
              GridView.count(
                crossAxisCount: 3,
                children: List.generate(100, (index) {
                  return Center(
                    child: Text(
                      'Tab 2 - Item $index',
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SliverFillRemaining _buildSliverContent() {
    return const SliverFillRemaining(
      child: Center(
          child: Text(
        'Gallery',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      )),
    );
  }
}
