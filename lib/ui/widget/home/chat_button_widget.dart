import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';

class ChatButtonWidget extends StatefulWidget {
  ChatButtonWidget({super.key, required this.index});

  int index;

  @override
  State<ChatButtonWidget> createState() => _ChatButtonWidgetState();
}

class _ChatButtonWidgetState extends State<ChatButtonWidget> {
  final TextEditingController _textController = TextEditingController();
  late VideoPlayProvider _videoPlayProvider;

  List<String> userimgs = [
    'assets/images/chat_user_1.png',
    'assets/images/chat_user_2.png',
    'assets/images/chat_user_3.png',
    'assets/images/chat_user_4.png',
    'assets/images/chat_user_5.png',
    'assets/images/chat_user_6.png',
  ];

  List<String> users = [
    'hello_kiti',
    'pochako',
    'pom_pom_pulin',
    'kelo_kelo_kelopi',
    'kogimyung_',
    'teogsido_saem'
  ];

  List<String> chats = [
    '어디 가면 볼 수 있나요?',
    '너무 아름다워요..',
    '태연 팬 아닌데 이건 레전드',
    '어떻게 노래도 잘하고 춤도 잘춰 ㅜ',
    '코디 열일하네',
    '예뻐요오',
  ];

  List<String> dates = [
    '2023-04-07',
    '2023-04-08',
    '2023-04-09',
    '2023-04-10',
    '2023-04-11',
    '2023-04-12',
  ];

  List<String> emojiList = [
    '⭐',
    '🌸',
    '🧸',
    '🧡',
    '😍',
    '🔥',
    '🌙',
    '💕',
  ];

  List<Widget> textWidgets = [];

  Color postTextColor = AppColor.blueColor4;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < emojiList.length; i++) {
      String emoji = emojiList[i];

      Widget textWidget = InkWell(
        onTap: () {
          _textController.text += emoji;
        },
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      );

      textWidgets.add(textWidget);
    }

    _textController.addListener(() {
      setState(() {
        postTextColor = _textController.text.isNotEmpty
            ? AppColor.blueColor5
            : AppColor.blueColor4;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return InkWell(
      onTap: () => {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0),
            ),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          builder: (context) {
            return SizedBox(
              height: 500,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    centerTitle: true,
                    title: Text(
                      '댓글 ${_videoPlayProvider.chats[widget.index]}개',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  resizeToAvoidBottomInset: true,
                  body: Padding(
                    padding: const EdgeInsets.only(bottom: 110),
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 18)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                userimgs[index],
                                width: 35,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 8)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  users[index],
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(bottom: 8)),
                                Text(
                                  chats[index],
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(bottom: 4)),
                                Text(
                                  dates[index],
                                  style: TextStyle(
                                      fontSize: 10, color: AppColor.grayColor2),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(bottom: 20)),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  bottomSheet: SizedBox(
                    height: 110,
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: textWidgets,
                          ),
                        ),
                        Container(
                          height: 65,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              const Padding(padding: EdgeInsets.only(left: 18)),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  _videoPlayProvider.profiles[widget.index],
                                  width: 40,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 18)),
                              Expanded(
                                child: Container(
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: AppColor.grayColor2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(left: 18)),
                                      Expanded(
                                        child: TextField(
                                          controller: _textController,
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            hintText:
                                                '${_videoPlayProvider.nicknames[widget.index]}(으)로 댓글 달기...',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                            labelStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                            border: InputBorder.none,
                                          ),
                                          textInputAction: TextInputAction.next,
                                          onChanged: (_) {
                                            setState(() {
                                              postTextColor = _textController
                                                      .text.isNotEmpty
                                                  ? AppColor.blueColor5
                                                  : AppColor.blueColor4;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        '게시',
                                        style: TextStyle(
                                            color: postTextColor, fontSize: 12),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 18)),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 18)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      },
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'assets/icons/ic_home_chat.svg',
          ),
          const Padding(padding: EdgeInsets.only(bottom: 2)),
          Text(
            _videoPlayProvider.chats[widget.index],
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
