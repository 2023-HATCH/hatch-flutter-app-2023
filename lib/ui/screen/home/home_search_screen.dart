import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/search_provider.dart';
import 'package:pocket_pose/ui/view/home/search_grid_view.dart';
import 'package:provider/provider.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen>
    with SingleTickerProviderStateMixin {
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();

  List<String> followingProfileList = [
    'assets/images/chat_user_1.png',
    'assets/images/chat_user_2.png',
    'assets/images/chat_user_3.png',
    'assets/images/chat_user_4.png',
    'assets/images/chat_user_5.png',
    'assets/images/chat_user_6.png',
  ];

  List<String> followingNicknameList = [
    'hello_kiti',
    'pochako',
    'pom_pom_pulin',
    'kelo_kelo_kelopi',
    'kogimyung_',
    'teogsido_saem'
  ];

  List<String> followingIntroduceList = [
    '안녕 난 키티야',
    '',
    '푸루루루푸우린',
    '케로로 아님',
    '',
    ''
  ];

  List<bool> followingList = [
    true,
    true,
    false,
    true,
    true,
    true,
  ];

  List<String> followerProfileList = [
    'assets/images/chat_user_4.png',
    'assets/images/chat_user_5.png',
    'assets/images/chat_user_6.png',
  ];

  List<String> followerNicknameList = [
    'kelo_kelo_kelopi',
    'kogimyung_',
    'teogsido_saem'
  ];

  List<String> followerIntroduceList = ['케로로 아님', '', ''];

  List<bool> followerList = [
    false,
    true,
    true,
  ];

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);

    _multiVideoPlayProvider.pauseVideo(0);

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();

    _multiVideoPlayProvider.playVideo(0);
    _tabController.dispose();
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
            icon: Image.asset(
              'assets/icons/ic_back.png',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: const SearchVideoGridView()

        // Column(
        //   children: [
        //     SearchTextField(textController: _textController),
        //     TabBar(
        //       controller: _tabController,
        //       labelColor: Colors.black,
        //       unselectedLabelColor: AppColor.grayColor3,
        //       indicatorColor: AppColor.purpleColor,
        //       tabs: const [
        //         Tab(text: '계정'),
        //         Tab(text: '태그'),
        //       ],
        //     ),
        //     Expanded(
        //       child: TabBarView(
        //         controller: _tabController,
        //         children: [
        //           FollowListViewWidget(
        //             tabNum: 0,
        //             isfollows: followerList,
        //             profiles: followerProfileList,
        //             nicknames: followerNicknameList,
        //             introduces: followerIntroduceList,
        //           ),
        //           VideoGridView(),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}

class SearchTextField extends StatefulWidget {
  const SearchTextField(
      {super.key, required TextEditingController textController})
      : _textController = textController;

  final TextEditingController _textController;

  @override
  State<StatefulWidget> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
  }

  Future<bool> getTags() async {
    return await _searchProvider.getTags();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getTags(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_searchProvider.tagResponse != null) {
            return SizedBox(
              height: 40,
              child: Row(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(left: 18)),
                  Expanded(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.grayColor4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 14)),
                          SvgPicture.asset(
                            'assets/icons/ic_home_search.svg',
                            color: Colors.grey,
                            width: 14,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 8)),
                          Expanded(
                              child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: widget._textController,
                              decoration: const InputDecoration(
                                hintText: '검색',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                labelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return _searchProvider.tagResponse!.where(
                                  (item) => item
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()));
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion,
                                  style: TextStyle(
                                    color: AppColor.grayColor,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              widget._textController.text = suggestion;

                              // 검색 처리 api 호출
                              // 태그 검색 api 호출
                              debugPrint('태그: $suggestion');
                              _searchProvider.getTagSearch(suggestion,
                                  const VideosRequest(page: 0, size: 3));

                              // 유저 검색 api 호출
                              _searchProvider.getUserSearch(suggestion);
                            },
                            noItemsFoundBuilder: (context) {
                              return GestureDetector(
                                child: ListTile(
                                  leading: const Icon(Icons.search),
                                  title: Text(
                                    widget._textController.text,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // 검색 처리 api 호출
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          )),
                          const Padding(padding: EdgeInsets.only(left: 14)),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 18)),
                ],
              ),
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
      },
    );
  }
}

// ignore: must_be_immutable
class FollowListViewWidget extends StatefulWidget {
  FollowListViewWidget({
    Key? key,
    required this.tabNum,
    required this.isfollows,
    required this.profiles,
    required this.nicknames,
    required this.introduces,
  }) : super(key: key);

  int tabNum;
  List<bool> isfollows;
  List<String> profiles;
  List<String> nicknames;
  List<String> introduces;

  @override
  State<StatefulWidget> createState() => _FollowListViewWidgetState();
}

class _FollowListViewWidgetState extends State<FollowListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.isfollows.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      widget.profiles[index],
                      width: 35,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nicknames[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (widget.introduces[index].isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(bottom: 8)),
                            Text(
                              widget.introduces[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
