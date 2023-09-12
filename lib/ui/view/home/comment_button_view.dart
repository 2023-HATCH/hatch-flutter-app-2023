// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/comment_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/comment_data.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/screen/profile/profile_screen.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';
import 'package:provider/provider.dart';

class CommentButtonView extends StatefulWidget {
  const CommentButtonView(
      {super.key,
      required this.screenNum,
      required this.index,
      required this.onRefresh,
      required this.videoId,
      required this.commentCount,
      required this.childWidget,
      this.isopenComment});

  final int screenNum;
  final int index;
  final VoidCallback onRefresh;
  final String videoId;
  final int commentCount;
  final Widget childWidget;
  final bool? isopenComment;

  @override
  State<CommentButtonView> createState() => _CommentButtonViewState();
}

class _CommentButtonViewState extends State<CommentButtonView> {
  final TextEditingController _textController = TextEditingController();
  late KaKaoLoginProvider _loginProvider;
  late final CommentProvider _commentProvider =
      Provider.of<CommentProvider>(context, listen: false);
  List<CommentData>? _commentList = [];
  final ScrollController _scrollController = ScrollController();
  late final MultiVideoPlayProvider _multiVideoPlayProvider =
      Provider.of<MultiVideoPlayProvider>(context, listen: false);
  bool _isInit = false;
  UserData? user;
  bool _isNotEmptyComment = false;
  final String _profileImg = 'assets/images/charactor_popo_default.png';
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

        if (mounted) {
          bottomState(() {
            setState(() {
              _commentList = newCommentList?.reversed.toList();

              _isNotEmptyComment = _multiVideoPlayProvider
                      .videos[widget.screenNum][widget.index].commentCount >
                  0;
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
      final newUser = await _loginProvider.getUser();
      if (mounted) {
        bottomState(() {
          setState(() {
            user = newUser;
            _hintText = '${user!.nickname}(으)로 댓글 달기...';
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);

    _commentProvider.getComments(widget.videoId).then((value) {
      final newCommentList = _commentProvider.response?.commentList;
      if (mounted) {
        setState(() {
          _commentList = newCommentList?.reversed.toList();

          _isNotEmptyComment = _multiVideoPlayProvider
                  .videos[widget.screenNum][widget.index].commentCount >
              0;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openComment();
    });
  }

  void _openComment() async {
    // 댓글 알림을 확인하는 경우에만 댓글창 열림
    if (widget.isopenComment != null && widget.isopenComment!) {
      _ontap();
    }
  }

  void _ontap() async {
    if (_isInit) {
      if (await _loginProvider.checkAccessToken()) {
        user = await _loginProvider.getUser();
        if (mounted) {
          setState(() {
            _hintText = '${user!.nickname}(으)로 댓글 달기...';
          });
        }
      }
    }
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
                  toolbarHeight: 54,
                  automaticallyImplyLeading: false,
                  elevation: 0.4,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  centerTitle: true,
                  title: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 2, bottom: 15), // 바와 글씨 사이의 간격 조정
                        height: 4,
                        width: 40, // 바의 너비 설정
                        decoration: BoxDecoration(
                          color: AppColor.grayColor4,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      const Text(
                        '댓글',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 95),
                    child: Visibility(
                        visible: _isNotEmptyComment,
                        replacement: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Center(child: Text('등록된 댓글이 없습니다. 🥲')),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: _commentList?.length,
                          itemBuilder: (context, index) {
                            final year = _commentList?[index].createdAt.year;
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
                            final createdAt = '$year-$month-$day $hour:$minute';

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 4, 0, 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // _multiVideoPlayProvider
                                            //     .pauseVideo(widget.screenNum);
                                            // PageRouteWithSlideAnimation
                                            //     pageRouteWithAnimation =
                                            //     PageRouteWithSlideAnimation(
                                            //         ProfileScreen(
                                            //             userId:
                                            //                 _commentList?[index]
                                            //                     .user
                                            //                     .userId));

                                            // Navigator.push(
                                            //         context,
                                            //         pageRouteWithAnimation
                                            //             .slideRitghtToLeft())
                                            //     .then((value) {
                                            //   _multiVideoPlayProvider
                                            //       .playVideo(widget.screenNum);
                                            // });
                                          },
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: _commentList?[index]
                                                          .user
                                                          .profileImg ==
                                                      null
                                                  ? Image.asset(
                                                      _profileImg,
                                                      width: 34,
                                                      height: 34,
                                                    )
                                                  : Image.network(
                                                      _commentList![index]
                                                          .user
                                                          .profileImg!,
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
                                                      width: 34,
                                                      height: 34,
                                                      fit: BoxFit.cover,
                                                    )),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 8)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // _multiVideoPlayProvider
                                                //     .pauseVideo(
                                                //         widget.screenNum);
                                                // PageRouteWithSlideAnimation
                                                //     pageRouteWithAnimation =
                                                //     PageRouteWithSlideAnimation(
                                                //         ProfileScreen(
                                                //             userId:
                                                //                 _commentList?[
                                                //                         index]
                                                //                     .user
                                                //                     .userId));
                                                // Navigator.push(
                                                //         context,
                                                //         pageRouteWithAnimation
                                                //             .slideRitghtToLeft())
                                                //     .then((value) {
                                                //   _multiVideoPlayProvider
                                                //       .playVideo(
                                                //           widget.screenNum);
                                                // });
                                              },
                                              child: Text(
                                                _commentList?[index]
                                                        .user
                                                        .nickname ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 8)),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  120,
                                              child: Text(
                                                _commentList?[index].content ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                maxLines: 50,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 4)),
                                            Text(
                                              createdAt,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColor.grayColor2),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: user != null &&
                                        user!.userId ==
                                            _commentList?[index].user.userId,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 4, 18, 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          _commentProvider
                                              .deleteComment(
                                                  _commentList?[index].uuid ??
                                                      '')
                                              .then((value) {
                                            _loadCommentList(bottomState);
                                            Fluttertoast.showToast(
                                                msg: '댓글이 삭제되었습니다.');
                                            if (mounted) {
                                              bottomState(() {
                                                setState(() {
                                                  _multiVideoPlayProvider
                                                      .videos[widget.screenNum]
                                                          [widget.index]
                                                      .commentCount--;
                                                });
                                              });
                                            }
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
                              ),
                            );
                          },
                        )),
                  ),
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
                              color: Colors.grey.withOpacity(1),
                              spreadRadius: 0.3,
                              blurRadius: 0.3,
                              offset: const Offset(0, 0.4),
                            ),
                          ],
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (int i = 0; i < emojiList.length; i++)
                                InkWell(
                                  onTap: () async {
                                    if (await _loginProvider
                                            .checkAccessToken() ==
                                        false) {
                                      Navigator.pop(context);
                                      _loginProvider.showLoginBottomSheet();
                                    } else {
                                      int cursorPosition =
                                          _textController.text.length;
                                      String text = _textController.text;
                                      String newText = text + emojiList[i];
                                      _textController.value = TextEditingValue(
                                        text: newText,
                                        selection: TextSelection.collapsed(
                                            offset: cursorPosition +
                                                emojiList[i].length),
                                      );

                                      if (mounted) {
                                        bottomState(() {
                                          setState(() {});
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    emojiList[i],
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
                                child: user == null || user!.profileImg == null
                                    ? Image.asset(
                                        _profileImg,
                                        width: 40,
                                        height: 40,
                                      )
                                    : Image.network(
                                        user!.profileImg!,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColor.purpleColor,
                                            ),
                                          );
                                        },
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )),
                            const Padding(padding: EdgeInsets.only(left: 12)),
                            Expanded(
                              child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: AppColor.grayColor2,
                                    width: 0.6,
                                  ),
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
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          hintText: _hintText,
                                          hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                          labelStyle: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                          border: InputBorder.none,
                                        ),
                                        onTap: () async {
                                          if (await _loginProvider
                                                  .checkAccessToken() ==
                                              false) {
                                            FocusScope.of(context).unfocus();
                                            Navigator.pop(context);
                                            _loginProvider
                                                .showLoginBottomSheet();
                                          } else {
                                            if (mounted) {
                                              bottomState(() {
                                                setState(() {
                                                  isClicked = true;
                                                });
                                              });
                                            }
                                          }
                                        },
                                        onChanged: (text) {
                                          if (mounted) {
                                            bottomState(() {
                                              setState(() {});
                                            });
                                          }
                                        },
                                        onEditingComplete: () {
                                          if (_textController.text.isNotEmpty) {
                                            // 댓글 등록 api 호출
                                            _commentProvider
                                                .postComment(widget.videoId,
                                                    _textController.text)
                                                .then((value) {
                                              // 댓글 목록 새로고침
                                              _loadCommentList(bottomState);
                                              _textController.clear();
                                              FocusScope.of(context).unfocus();
                                              if (mounted) {
                                                bottomState(() {
                                                  setState(() {
                                                    _multiVideoPlayProvider
                                                        .videos[
                                                            widget.screenNum]
                                                            [widget.index]
                                                        .commentCount++;
                                                  });
                                                });
                                              }
                                            });
                                          }
                                          _scrollController.animateTo(0,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut);
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _textController.text.isNotEmpty
                                          ? () {
                                              // 댓글 등록 api 호출
                                              _commentProvider
                                                  .postComment(widget.videoId,
                                                      _textController.text)
                                                  .then((value) {
                                                // 댓글 목록 새로고침
                                                _loadCommentList(bottomState);
                                                _textController.clear();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (mounted) {
                                                  bottomState(() {
                                                    setState(() {
                                                      _multiVideoPlayProvider
                                                          .videos[
                                                              widget.screenNum]
                                                              [widget.index]
                                                          .commentCount++;
                                                    });
                                                  });
                                                }
                                              });
                                              _scrollController.animateTo(0,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut);
                                            }
                                          : null,
                                      child: Text(
                                        '게시',
                                        style: TextStyle(
                                            color:
                                                _textController.text.isNotEmpty
                                                    ? AppColor.blueColor5
                                                    : AppColor.blueColor4,
                                            fontSize: 12),
                                      ),
                                    ),
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
        });
      },
    ).then((value) {
      widget.onRefresh();
      isClicked = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () async => _ontap(), child: widget.childWidget);
  }
}
