import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/video_viewer/screen/video_someone_screen.dart';
import 'package:provider/provider.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayProvider _videoPlayProvider;
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
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    _videoPlayProvider.pauseVideo();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _videoPlayProvider.playVideo();
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
      body: Column(
        children: [
          SearchTextField(textController: _textController),
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
                FollowListViewWidget(
                  tabNum: 0,
                  isfollows: followerList,
                  profiles: followerProfileList,
                  nicknames: followerNicknameList,
                  introduces: followerIntroduceList,
                ),
                VideoGridView(),
              ],
            ),
          ),
        ],
      ),
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
  late VideoPlayProvider _videoPlayProvider;

  @override
  void initState() {
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
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
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return _videoPlayProvider.tags.where((item) =>
                          item.toLowerCase().contains(pattern.toLowerCase()));
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
  }
}

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

class VideoGridView extends StatelessWidget {
  VideoGridView({
    super.key,
  });

  final List<String> _videoImagePath = [
    "profile_video_0",
    "profile_video_1",
    "profile_video_3",
    "profile_video_5",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_5",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_5",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_5",
  ];

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
                builder: (context) => VideoSomeoneScreen(index: index),
              ),
            );
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
                Image.asset(
                  "assets/images/${_videoImagePath[index]}.png",
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
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
      itemCount: _videoImagePath.length,
    );
  }
}
