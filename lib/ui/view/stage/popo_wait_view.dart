import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PoPoWaitView extends StatelessWidget {
  const PoPoWaitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80.0),
              const Text(
                "대기중...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "3명 이상 참여하면 시작됩니다!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              Flexible(
                child: SvgPicture.asset(
                  'assets/images/charactor_popo_wait.svg',
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(
            height: 60.0 + 150.0,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
