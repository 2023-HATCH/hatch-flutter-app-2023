import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';

class UploadSpinner extends StatefulWidget {
  const UploadSpinner({
    key,
  }) : super(key: key);

  @override
  State<UploadSpinner> createState() => _UploadSpinnerState();
}

class _UploadSpinnerState extends State<UploadSpinner> {
  bool _showLeftImage = true;
  late Timer _imageChangeTimer;
  late Timer _imageScaleTimer;
  double _imageScale = 1.0; // 이미지 크기 조절용 변수

  @override
  void initState() {
    super.initState();
    // 0.4초마다 _toggleImage 함수를 호출하여 이미지를 변경
    _imageChangeTimer =
        Timer.periodic(const Duration(milliseconds: 800), _toggleImage);
    // 0.2초마다 _toggleImageScale 함수를 호출하여 이미지 크기를 변경
    _imageScaleTimer =
        Timer.periodic(const Duration(milliseconds: 200), _toggleImageScale);
  }

  void _toggleImage(Timer timer) {
    setState(() {
      _showLeftImage = !_showLeftImage;
    });
  }

  void _toggleImageScale(Timer timer) {
    setState(() {
      _imageScale = (_imageScale == 1.0) ? 0.97 : 1.0;
    });
  }

  @override
  void dispose() {
    _imageChangeTimer.cancel();
    _imageScaleTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(1, 32, 32, 32).withOpacity(0.87),
      child: Stack(
        children: [
          const SpinKitRipple(
            size: 500.0,
            color: Color.fromARGB(255, 181, 181, 181),
          ),
          Center(
            child: Transform.scale(
              scale: _imageScale,
              child: SizedBox(
                width: 300,
                child: SvgPicture.asset(
                  _showLeftImage
                      ? 'assets/images/dance_popo_left.svg'
                      : 'assets/images/dance_popo_right.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
