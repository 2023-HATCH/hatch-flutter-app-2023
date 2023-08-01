import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:provider/provider.dart';

class ChatButtonWidget extends StatefulWidget {
  ChatButtonWidget({super.key, required this.index, required this.childWidget});

  int index;
  Widget childWidget;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    UserData user = _videoPlayProvider.videoList[widget.index].user;
    VideoData video = _videoPlayProvider.videoList[widget.index];

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
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter bottomState) {
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
                              '댓글 ${video.commentCount}개',
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
                                    const Padding(
                                        padding: EdgeInsets.only(left: 18)),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        userimgs[index],
                                        width: 35,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 8)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          users[index],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8)),
                                        Text(
                                          chats[index],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 4)),
                                        Text(
                                          dates[index],
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: AppColor.grayColor2),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 20)),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          bottomSheet: SizedBox(
                            height: 90,
                            child: Column(
                              children: [
                                Container(
                                  height: 25,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      for (int i = 0; i < emojiList.length; i++)
                                        InkWell(
                                          onTap: () {
                                            int cursorPosition =
                                                _textController.text.length;
                                            String text = _textController.text;
                                            String newText =
                                                text + emojiList[i];
                                            _textController.value =
                                                TextEditingValue(
                                              text: newText,
                                              selection:
                                                  TextSelection.collapsed(
                                                      offset: cursorPosition +
                                                          emojiList[i].length),
                                            );

                                            bottomState(() {
                                              setState(() {});
                                            });
                                          },
                                          child: Text(
                                            emojiList[i],
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 65,
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.only(left: 18)),
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            user.profileImg!,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColor.purpleColor,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                              'assets/images/charactor_popo_default.png',
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
                                            ),
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                          )),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 12)),
                                      Expanded(
                                        child: Container(
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: AppColor.grayColor2),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 18)),
                                              Expanded(
                                                child: TextField(
                                                  controller: _textController,
                                                  cursorColor: Colors.white,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        '${user.nickname}(으)로 댓글 달기...',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                    border: InputBorder.none,
                                                  ),
                                                  onChanged: (text) {
                                                    bottomState(() {
                                                      setState(() {});
                                                    });
                                                  },
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: _textController
                                                        .text.isNotEmpty
                                                    ? () {
                                                        _textController.clear();
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      }
                                                    : null,
                                                child: Text(
                                                  '게시',
                                                  style: TextStyle(
                                                      color: _textController
                                                              .text.isNotEmpty
                                                          ? AppColor.blueColor5
                                                          : AppColor.blueColor4,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 18)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            },
        child: widget.childWidget);
  }
}
