import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/comment_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/comment_data.dart';
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
  late final CommentProvider _commentProvider =
      Provider.of<CommentProvider>(context, listen: false);
  late List<CommentData>? _commentList;
  final ScrollController _scrollController = ScrollController();

  String _profileImg = 'assets/images/charactor_popo_default.png';
  String _hintText = '따듯한 말 한마디 남겨 주세요 💛';

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

  Future<void> _loadCommentList(StateSetter bottomState) async {
    try {
      _commentProvider.getComments(widget.videoId).then((value) {
        final newCommentList = _commentProvider.response?.commentList;

        if (newCommentList != null && newCommentList.isNotEmpty) {
          bottomState(() {
            setState(() {
              _commentList = newCommentList.reversed.toList();
            });
          });
        }
      });
    } catch (e) {
      debugPrint('댓글 목록 조회 api 호출 실패');
    } finally {}
  }

  void _initUser(StateSetter bottomState) async {
    if (await _loginProvider.checkAccessToken()) {
      bottomState(() {
        setState(() {
          _profileImg =
              _profileImg ?? 'assets/images/charactor_popo_default.png';
          _hintText = '{user.nickname}(으)로 댓글 달기...';
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);
    _commentList = _commentProvider.response?.commentList;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _initUser(bottomState);
                    _loadCommentList(bottomState);
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
                            padding: const EdgeInsets.only(bottom: 95),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: _commentList?.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 18)),
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          _commentList?[index]
                                                  .user
                                                  .profileImg ??
                                              'assets/images/charactor_popo_default.png',
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.purpleColor,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            'assets/images/charactor_popo_default.png',
                                            fit: BoxFit.cover,
                                            width: 35,
                                            height: 35,
                                          ),
                                          fit: BoxFit.cover,
                                          width: 35,
                                          height: 35,
                                        )),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 8)),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _commentList?[index].user.nickname ??
                                              '',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8)),
                                        Text(
                                          _commentList?[index].content ?? '',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 4)),
                                        Text(
                                          '${_commentList?[index].createdAt.year}-${_commentList?[index].createdAt.month}-${_commentList?[index].createdAt.day} ${_commentList?[index].createdAt.hour}:${_commentList?[index].createdAt.minute}',
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
                            height: 95,
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                    if (await _loginProvider
                                                            .checkAccessToken() ==
                                                        false) {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      Navigator.pop(context);
                                                      _loginProvider
                                                          .showLoginBottomSheet();
                                                    }
                                                  },
                                                  onChanged: (text) {
                                                    bottomState(() {
                                                      setState(() {});
                                                    });
                                                  },
                                                  onEditingComplete: () {
                                                    if (_textController
                                                        .text.isNotEmpty) {
                                                      // 댓글 등록 api 호출
                                                      _commentProvider
                                                          .postComment(
                                                              widget.videoId,
                                                              _textController
                                                                  .text)
                                                          .then((value) {
                                                        // 댓글 목록 새로고침
                                                        _loadCommentList(
                                                            bottomState);
                                                        _textController.clear();
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      });
                                                    }
                                                    _scrollController.animateTo(
                                                        0,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        curve:
                                                            Curves.easeInOut);
                                                  },
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: _textController
                                                        .text.isNotEmpty
                                                    ? () {
                                                        // 댓글 등록 api 호출
                                                        _commentProvider
                                                            .postComment(
                                                                widget.videoId,
                                                                _textController
                                                                    .text)
                                                            .then((value) {
                                                          // 댓글 목록 새로고침
                                                          _loadCommentList(
                                                              bottomState);
                                                          _textController
                                                              .clear();
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                        });
                                                        _scrollController.animateTo(
                                                            0,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            curve: Curves
                                                                .easeInOut);
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
