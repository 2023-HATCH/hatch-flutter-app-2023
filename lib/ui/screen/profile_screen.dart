import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/local/provider/auth_provider.dart';
import 'package:pocket_pose/ui/widget/profile/profile_infomation_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AuthProvider authProvider;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 14, 14, 0),
                                    child: SvgPicture.asset(
                                        'assets/icons/ic_profile_edit.svg')),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 14, 14, 0),
                                    child: SvgPicture.asset(
                                        'assets/icons/ic_profile_setting.svg')),
                              ],
                            ),
                            ProfileInfomationWidget(),
                          ],
                        ),
                      ),
                  childCount: 1),
            ),
            const SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.dashboard),
                  Icon(Icons.tv),
                  Icon(Icons.person),
                ],
              ),
            ),
            // SliverAnimatedList(
            //   itemBuilder: (_, index, ___) {
            //     return ListTile(
            //       title: Text(index.toString()),
            //     );
            //   },
            //   initialItemCount: 100,
            // ),
            SliverAnimatedGrid(
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
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   authProvider = Provider.of<AuthProvider>(context);

  //   return authProvider.accessToken != null
  //       //토큰이 존재할 경우
  //       ? Scaffold(
  //           appBar: AppBar(
  //             backgroundColor: Colors.transparent, //appBar 투명색
  //             elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
  //             actions: [
  //               Container(
  //                   margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
  //                   child:
  //                       SvgPicture.asset('assets/icons/ic_profile_edit.svg')),
  //               Container(
  //                   margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
  //                   child: SvgPicture.asset(
  //                       'assets/icons/ic_profile_setting.svg')),
  //             ],
  //           ),
  //           extendBodyBehindAppBar: true, //body 위에 appbar
  //           body: Column(
  //             children: [
  //               //(1)
  //               ProfileInfomationWidget(),
  //               //(2)
  //               const GridTabBarWidget()
  //             ],
  //           ),
  //         )

  //       //토큰이 존재하지 않는 경우
  //       : const NotLoginWidget();
  // }
}
