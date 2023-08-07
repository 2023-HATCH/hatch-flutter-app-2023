import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/comment_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/comment_data.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CommentButtonWidget extends StatefulWidget {
  CommentButtonWidget(
      {super.key,
      required this.index,
      required this.onRefresh,
      required this.videoId,
      required this.commentCount,
      required this.childWidget});

  int index;
  VoidCallback onRefresh;
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
  late final VideoPlayProvider _videoPlayProvider =
      Provider.of<VideoPlayProvider>(context, listen: false);
  bool _isInit = false;
  UserData? user;
  bool _isNotEmptyComment = false;
  String _profileImg = 'assets/images/charactor_popo_default.png';
  String _hintText = '따듯한 말 한마디 남겨 주세요 💛';
  bool isClicked = false;

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

        bottomState(() {
          setState(() {
            _commentList = newCommentList?.reversed.toList();

            // commentCount api 완성되면 삭제
            _isNotEmptyComment =
                _commentList != null || _commentList!.isNotEmpty;
            // commentCount api 완성되면 주석 해제
            // _isNotEmptyComment =_videoPlayProvider.videoList[widget.index].commentCount > 0;
          });
        });
      });
    } catch (e) {
      debugPrint('댓글 목록 조회 api 호출 실패');
    } finally {}
  }

  void _initUser(StateSetter bottomState) async {
    if (await _loginProvider.checkAccessToken()) {
      final newUser = await _loginProvider.getUser();
      bottomState(() {
        setState(() {
          user = newUser;
          _profileImg =
              user!.profileImg ?? 'assets/images/charactor_popo_default.png';
          _hintText = '${user!.nickname}(으)로 댓글 달기...';
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);

    _commentProvider.getComments(widget.videoId).then((value) {
      final newCommentList = _commentProvider.response?.commentList;

      setState(() {
        _commentList = newCommentList?.reversed.toList();

        // commentCount api 완성되면 삭제
        _isNotEmptyComment = _commentList != null || _commentList!.isNotEmpty;
        // commentCount api 완성되면 주석 해제
        // _isNotEmptyComment =_videoPlayProvider.videoList[widget.index].commentCount > 0;
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
    return InkWell(
        onTap: () async => {
              if (_isInit)
                {
                  if (await _loginProvider.checkAccessToken())
                    {
                      user = await _loginProvider.getUser(),
                      setState(() {
                        _profileImg = user!.profileImg ??
                            'assets/images/charactor_popo_default.png';
                        _hintText = '${user!.nickname}(으)로 댓글 달기...';
                      }),
                    }
                },
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
                    if (!_isInit) {
                      _initUser(bottomState);
                      _isInit = true;
                    }

                    return SizedBox(
                      height: isClicked == false
                          ? 500
                          : MediaQuery.of(context).size.height - 100,
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
                              '댓글 ${_videoPlayProvider.videoList[widget.index].commentCount}개',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          resizeToAvoidBottomInset: true,
                          body: Padding(
                            padding: const EdgeInsets.only(bottom: 95),
                            child: Visibility(
                                visible: _isNotEmptyComment,
                                replacement:
                                    const Center(child: Text('등록된 댓글이 없습니다.')),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: _commentList?.length,
                                  itemBuilder: (context, index) {
                                    final year =
                                        _commentList?[index].createdAt.year;
                                    final month = _commentList?[index]
                                        .createdAt
                                        .month
                                        .toString()
                                        .padLeft(2, '0');

                                    final day = _commentList?[index]
                                        .createdAt
                                        .day
                                        .toString()
                                        .padLeft(2, '0');

                                    final hour = _commentList?[index]
                                        .createdAt
                                        .hour
                                        .toString()
                                        .padLeft(2, '0');
                                    final minute = _commentList?[index]
                                        .createdAt
                                        .minute
                                        .toString()
                                        .padLeft(2, '0');
                                    final createdAt =
                                        '$year-$month-$day $hour:$minute';

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 4, 0, 12),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    _commentList?[index]
                                                            .user
                                                            .profileImg ??
                                                        'assets/images/charactor_popo_default.png',
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColor
                                                              .purpleColor,
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
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
                                                  padding:
                                                      EdgeInsets.only(left: 8)),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _commentList?[index]
                                                            .user
                                                            .nickname ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8)),
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(
                                                      _commentList?[index]
                                                              .content ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                      maxLines: 10,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 4)),
                                                  Text(
                                                    createdAt,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: AppColor
                                                            .grayColor2),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: user != null &&
                                              user!.userId ==
                                                  _commentList?[index]
                                                      .user
                                                      .userId,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4, 18, 12),
                                            child: GestureDetector(
                                              onTap: () {
                                                _commentProvider
                                                    .deleteComment(
                                                        _commentList?[index]
                                                                .uuid ??
                                                            '')
                                                    .then((value) {
                                                  _loadCommentList(bottomState);
                                                  Fluttertoast.showToast(
                                                      msg: '댓글이 삭제되었습니다.');
                                                  bottomState(() {
                                                    setState(() {
                                                      _videoPlayProvider
                                                          .videoList[
                                                              widget.index]
                                                          .commentCount--;
                                                    });
                                                  });
                                                });
                                              },
                                              child: Text(
                                                '삭제',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: AppColor.grayColor2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )),
                          ),
                          bottomSheet: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
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
                                                    } else {
                                                      bottomState(() {
                                                        setState(() {
                                                          isClicked = true;
                                                        });
                                                      });
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

                                                        bottomState(() {
                                                          setState(() {
                                                            _videoPlayProvider
                                                                .videoList[
                                                                    widget
                                                                        .index]
                                                                .commentCount++;
                                                          });
                                                        });
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
                                                          bottomState(() {
                                                            setState(() {
                                                              _videoPlayProvider
                                                                  .videoList[
                                                                      widget
                                                                          .index]
                                                                  .commentCount++;
                                                            });
                                                          });
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
              ).then((value) {
                widget.onRefresh();
                isClicked = false;
              })
            },
        child: widget.childWidget);
  }
}
