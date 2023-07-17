import 'package:flutter/material.dart';

import '../../config/app_color.dart';

class CenterTitleAppBar extends StatefulWidget {
  CenterTitleAppBar({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  State<StatefulWidget> createState() => _CenterTitleAppBarState();
}

class _CenterTitleAppBarState extends State<CenterTitleAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
    );
  }
}
