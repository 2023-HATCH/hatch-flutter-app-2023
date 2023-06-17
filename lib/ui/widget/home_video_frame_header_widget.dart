import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VideoFrameHeaderWidget extends StatelessWidget {
  const VideoFrameHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      margin: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/home_popo.svg',
            ),
            Row(children: <Widget>[
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'upload 클릭');
                },
                child: SvgPicture.asset(
                  'assets/icons/home_upload.svg',
                  width: 18,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 18)),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'search 클릭');
                },
                child: SvgPicture.asset(
                  'assets/icons/home_search.svg',
                  width: 18,
                ),
              ),
            ]),
          ]),
    );
  }
}
