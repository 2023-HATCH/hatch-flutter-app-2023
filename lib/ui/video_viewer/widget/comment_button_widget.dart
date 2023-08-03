import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/comment_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CommentButtonWidget extends StatefulWidget {
  CommentButtonWidget(
      {super.key,
      required this.videoId,
      required this.commentCount,
      required this.childWidget});

  String videoId;
  int commentCount;
  Widget childWidget;

  @override
  State<CommentButtonWidget> createState() => _CommentButtonWidgetState();
}

class _CommentButtonWidgetState extends State<CommentButtonWidget> {
  final TextEditingController _textController = TextEditingController();
  late KaKaoLoginProvider _loginProvider;

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

  String _profileImg = 'assets/images/charactor_popo_default.png';
  String _hintText = '따듯한 말 한마디 남겨 주세요 💛';
  late CommentProvider _commentProvider;

  Future<void> _loadCommentList() async {
    try {
      _commentProvider.getComments(widget.videoId).then((value) {
        final comments = _commentProvider.response?.commentList;

        if (comments != null && comments.isNotEmpty) {
          setState(() {
            comments;
          });
        }
      });
    } catch (e) {
      debugPrint('댓글 목록 조회 api 호출 실패');
    } finally {}
  }

  void initUser() async {
    if (await _loginProvider.checkAccessToken()) {
      // 로그인
      _profileImg = _profileImg ?? 'assets/images/charactor_popo_default.png';
      _hintText = '{user.nickname}(으)로 댓글 달기...';
    }
  }

  @override
  void initState() {
    super.initState();
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initUser();

    _commentProvider = Provider.of<CommentProvider>(context, listen: false);
    return InkWell(
        onTap: () => {
              _loadCommentList(),
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
                              '댓글 ${widget.commentCount}개',
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
                                          onTap: () async {
                                            if (await _loginProvider
                                                    .checkAccessToken() ==
                                                false) {
                                              Navigator.pop(context);
                                              _loginProvider
                                                  .showLoginBottomSheet();
                                            } else {
                                              int cursorPosition =
                                                  _textController.text.length;
                                              String text =
                                                  _textController.text;
                                              String newText =
                                                  text + emojiList[i];
                                              _textController.value =
                                                  TextEditingValue(
                                                text: newText,
                                                selection:
                                                    TextSelection.collapsed(
                                                        offset: cursorPosition +
                                                            emojiList[i]
                                                                .length),
                                              );

                                              bottomState(() {
                                                setState(() {});
                                              });
                                            }
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
                                            _profileImg ??
                                                'assets/images/charactor_popo_default.png',
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
                                                    hintText: _hintText,
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                    labelStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                    border: InputBorder.none,
                                                  ),
                                                  onTap: () async {
                                                    bottomState(() {
                                                      setState(() async {
                                                        if (await _loginProvider
                                                                .checkAccessToken() ==
                                                            false) {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          Navigator.pop(
                                                              context);
                                                          _loginProvider
                                                              .showLoginBottomSheet();
                                                        }
                                                      });
                                                    });
                                                  },
                                                  onChanged: (text) {
                                                    bottomState(() {
                                                      setState(() {});
                                                    });
                                                  },
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  setState(() async {
                                                    if (await _loginProvider
                                                            .checkAccessToken() ==
                                                        false) {
                                                      Navigator.pop(context);
                                                      _loginProvider
                                                          .showLoginBottomSheet();
                                                    } else {
                                                      _textController
                                                              .text.isNotEmpty
                                                          ? () {
                                                              // 댓글 작성
                                                              _commentProvider
                                                                  .postComment(
                                                                      widget
                                                                          .videoId,
                                                                      _textController
                                                                          .text)
                                                                  .then(
                                                                (value) {
                                                                  // 댓글 목록 새로고침
                                                                  _loadCommentList();
                                                                  // 댓글 입력창 초기화
                                                                  _textController
                                                                      .clear();
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                },
                                                              );
                                                            }
                                                          : null;
                                                    }
                                                  });
                                                },
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
