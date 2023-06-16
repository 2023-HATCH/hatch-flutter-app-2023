import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PoPoWaitView extends StatefulWidget {
  const PoPoWaitView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PoPoWaitViewState();
}

class _PoPoWaitViewState extends State<PoPoWaitView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100.0,
            width: double.infinity,
          ),
          const Text(
            "대기중...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          const SizedBox(height: 40.0),
          const Text(
            "3명 이상 참여하면 시작됩니다!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 40.0),
          SvgPicture.asset(
            'assets/images/charactor_popo_wait.svg',
          ),
        ],
      ),
    );
  }
}
