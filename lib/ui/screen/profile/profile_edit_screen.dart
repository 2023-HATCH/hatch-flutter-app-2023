import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final List<TextEditingController> _textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  bool isButtonEnabled() {
    for (final controller in _textControllers) {
      if (controller.text.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
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
      ),
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
                  child: Image.asset(
                    'assets/images/profile_profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 14),
                child: const Text(
                  "cat_chur",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 50.0),
              Container(
                height: 36,
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.grayColor2),
                ),
                child: TextField(
                  controller: _textControllers[0],
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: '자기소개',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/ic_profile_edit_warning.svg'),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '10자 이내로 입력해 주세요.',
                    style: TextStyle(color: AppColor.grayColor3, fontSize: 10),
                  ),
                ],
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
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.grayColor2),
                      ),
                      child: TextField(
                        controller: _textControllers[1],
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintText: 'Instagram',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
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
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.grayColor2),
                      ),
                      child: TextField(
                        controller: _textControllers[2],
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintText: 'twitter',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(35, 0, 35, 20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isButtonEnabled() ? () => {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled()
                      ? AppColor.purpleColor
                      : AppColor.grayColor3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
