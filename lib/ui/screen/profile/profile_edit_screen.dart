import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/profile_edit_request.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({required this.profileResponse, Key? key})
      : super(key: key);
  final ProfileResponse profileResponse;

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late ProfileProvider _profileProvider;
  List<TextEditingController> _textControllers = [];

  final List<bool> _isClickeds = [
    false,
    false,
    false,
  ];

  bool isButtonEnabled() {
    if (_isClickeds[0] &&
        _textControllers[0].text != widget.profileResponse.profile.introduce) {
      return true;
    }
    if (_isClickeds[1] &&
        _textControllers[1].text !=
            widget.profileResponse.profile.instagramId) {
      return true;
    }
    if (_isClickeds[2] &&
        _textControllers[2].text != widget.profileResponse.profile.twitterId) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();

    _textControllers = [
      TextEditingController(
        text: widget.profileResponse.profile.introduce == null ||
                widget.profileResponse.profile.introduce == ''
            ? '자기소개'
            : widget.profileResponse.profile.introduce,
      ),
      TextEditingController(
        text: widget.profileResponse.profile.instagramId == null ||
                widget.profileResponse.profile.instagramId == ''
            ? 'Instagram'
            : widget.profileResponse.profile.instagramId,
      ),
      TextEditingController(
        text: widget.profileResponse.profile.twitterId == null ||
                widget.profileResponse.profile.twitterId == ''
            ? 'Twitter'
            : widget.profileResponse.profile.twitterId,
      ),
    ];

    for (final controller in _textControllers) {
      controller.addListener(updateButtonState);
    }
  }

  void updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    for (final controller in _textControllers) {
      controller.removeListener(updateButtonState);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: const Text(
            '프로필 편집',
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(
              height: 2.0,
              color: AppColor.purpleColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: isButtonEnabled()
                  ? () {
                      // 버튼 클릭시 프로필 수정

                      _profileProvider.patchProfile(ProfileEditRequest(
                          introduce: _textControllers[0].text,
                          instagramId: _textControllers[1].text,
                          twitterId: _textControllers[2].text));

                      Fluttertoast.showToast(msg: '수정되었습니다!');
                      // profileResponse 새로고침
                      _profileProvider.isGetProfilDone = false;
                      Navigator.pop(context);
                    }
                  : null,
              child: Text(
                '수정',
                style: TextStyle(
                  color: isButtonEnabled()
                      ? AppColor.purpleColor
                      : AppColor.purpleColor3,
                ),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 50, 35, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      widget.profileResponse.user.profileImg!,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.purpleColor,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/charactor_popo_default.png',
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 14),
                child: Text(
                  widget.profileResponse.user.nickname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 50.0),
              SizedBox(
                height: 54,
                child: TextField(
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: '자기소개',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.grayColor4),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.purpleColor3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  controller: _textControllers[0],
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: _isClickeds[0]
                        ? Colors.black
                        : widget.profileResponse.profile.introduce == null ||
                                widget.profileResponse.profile.introduce == ''
                            ? Colors.black12
                            : Colors.black45,
                    fontSize: 14,
                  ),
                  onTap: () {
                    if (!_isClickeds[0]) {
                      setState(() {
                        _textControllers[0].text =
                            (widget.profileResponse.profile.introduce == null ||
                                    widget.profileResponse.profile.introduce ==
                                        ''
                                ? '자기소개'
                                : widget.profileResponse.profile.introduce)!;

                        _isClickeds[0] = true;
                      });
                    }
                    Future.delayed(Duration.zero, () {
                      _textControllers[0].selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: _textControllers[0].text.length),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: AppColor.grayColor3,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    '소셜',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: AppColor.grayColor3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18.0),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/ic_profile_edit_instagram.png',
                  ),
                  const SizedBox(width: 18.0),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: TextField(
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: 'Instagram',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.grayColor4),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.purpleColor3),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: _textControllers[1],
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: _isClickeds[1]
                              ? Colors.black
                              : widget.profileResponse.profile.instagramId ==
                                          null ||
                                      widget.profileResponse.profile
                                              .instagramId ==
                                          ''
                                  ? Colors.black12
                                  : Colors.black45,
                          fontSize: 14,
                        ),
                        onTap: () {
                          if (!_isClickeds[1]) {
                            setState(() {
                              _textControllers[1].text =
                                  (widget.profileResponse.profile.instagramId ==
                                              null ||
                                          widget.profileResponse.profile
                                                  .instagramId ==
                                              ''
                                      ? 'Instagram'
                                      : widget.profileResponse.profile
                                          .instagramId)!;

                              _isClickeds[1] = true;
                            });
                          }
                          Future.delayed(Duration.zero, () {
                            _textControllers[1].selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _textControllers[1].text.length),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/ic_profile_edit_twitter.png',
                  ),
                  const SizedBox(width: 18.0),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: TextField(
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: 'Twitter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.grayColor4),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor.purpleColor3),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: _textControllers[2],
                        cursorColor: Colors.black,
                        style: TextStyle(
                          color: _isClickeds[2]
                              ? Colors.black
                              : widget.profileResponse.profile.twitterId ==
                                          null ||
                                      widget.profileResponse.profile
                                              .twitterId ==
                                          ''
                                  ? Colors.black12
                                  : Colors.black45,
                          fontSize: 14,
                        ),
                        onTap: () {
                          if (!_isClickeds[2]) {
                            setState(() {
                              _textControllers[2].text = (widget.profileResponse
                                              .profile.twitterId ==
                                          null ||
                                      widget.profileResponse.profile
                                              .twitterId ==
                                          ''
                                  ? 'Twitter'
                                  : widget.profileResponse.profile.twitterId)!;

                              _isClickeds[2] = true;
                            });
                          }
                          Future.delayed(Duration.zero, () {
                            _textControllers[2].selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _textControllers[2].text.length),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
