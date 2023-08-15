import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:provider/provider.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'dart:math' as math;

class PoPoCatchView extends StatefulWidget {
  final StageType type;
  const PoPoCatchView({Key? key, required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PoPoCatchViewState();
}

class _PoPoCatchViewState extends State<PoPoCatchView>
    with SingleTickerProviderStateMixin {
  int _milliseconds = 0;
  double _catchCountDown = 0.0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;
  StageType _prevStageType = StageType.CATCH_START;

  @override
  Widget build(BuildContext context) {
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: true);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: true);

    _onMidEnter();

    // 캐치 재진행인 경우 토스트 띄우고 카운트다운 재시작
    if (_prevStageType != widget.type) {
      _reCountDown();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60.0),
              const Text(
                "이번 곡은...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              musicTitleContainer(
                  '${_socketStageProvider.catchMusicData?.singer} - ${_socketStageProvider.catchMusicData?.title}'),
              const SizedBox(height: 10.0),
              Flexible(
                child: SvgPicture.asset(
                  'assets/images/charactor_popo_catch.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 90),
                child: CustomPaint(
                  painter: CatchCountDownPainter(),
                ),
              ),
              _buildCatchButton(),
            ],
          ),
        ),
        const Flexible(flex: 1, child: SizedBox(height: 60.0 + 150.0)),
      ],
    );
  }

  void _onMidEnter() {
    if (_socketStageProvider.isCatchMidEnter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _socketStageProvider.setIsCatchMidEnter(false);
        // 중간임장인 경우
        if (_stageProvider.stageCurTime != null) {
          // 중간 입장한 초부터 시작
          setState(() {
            _milliseconds = (_stageProvider.stageCurTime! / 1000000).round();
          });
          _stageProvider.setStageCurSecondNULL();
        }
      });
    }
  }

  void _reCountDown() {
    _prevStageType = widget.type;
    _milliseconds = 0;
    _catchCountDown = 0.0;
    _startTimer();
    Fluttertoast.showToast(
      msg: "캐치를 아무도 안 했어요...😢",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  SizedBox _buildCatchButton() {
    return SizedBox(
      width: 100,
      height: 45,
      child: SemicircularIndicator(
        progress: (_catchCountDown > 1) ? 1 : _catchCountDown,
        color: Colors.yellow,
        bottomPadding: 0,
        strokeWidth: 2,
        backgroundColor: Colors.transparent,
        child: InkWell(
          onTap: () {
            _playClickSound();
            _stageProvider.getStageCatch();
          },
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
          child: Text(
            '캐치!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              shadows: [
                for (double i = 1; i < 6; i++)
                  Shadow(color: AppColor.blueColor3, blurRadius: 5 * i)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_milliseconds >= 3000) {
        _stopTimer();
      } else {
        if (mounted) {
          setState(() {
            _milliseconds = _milliseconds + 10;
            _catchCountDown = _milliseconds / 3000;
          });
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stopTimer();
    super.dispose();
  }

  Widget musicTitleContainer(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 11, 70, 11),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, width: 3.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              for (double i = 1; i < 5; i++)
                BoxShadow(
                    color: AppColor.yellowColor,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 3 * i)
            ]),
        child: AnimatedOpacity(
          opacity: _opacityAnimation.value,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_music_note_big.svg',
                ),
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playClickSound() {
    AssetsAudioPlayer.newPlayer()
        .open(Audio("assets/audios/sound_catch_click.mp3"));
  }
}

class CatchCountDownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Outer 네온 효과
    final neonOuterPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..color = AppColor.blueColor3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    // Inner 네온 효과
    final neonInnerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..color = AppColor.blueColor3
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 3.0);

    // 흰 라인
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round // 끝을 둥글게
      ..color = Colors.white;

    // 검정 라인
    final innerBasePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round // 끝을 둥글게
      ..color = Colors.black;

    const rect = Rect.fromLTWH(0, 0, 90, 90);
    canvas.drawArc(rect, -math.pi, math.pi, false, neonOuterPaint);
    canvas.drawArc(rect, -math.pi, math.pi, false, neonInnerPaint);
    canvas.drawArc(rect, -math.pi, math.pi, false, basePaint);
    canvas.drawArc(rect, -math.pi, math.pi, false, innerBasePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
