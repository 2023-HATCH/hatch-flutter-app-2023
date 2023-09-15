import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_music_data.dart';
import 'package:pocket_pose/ui/widget/stage/stage_catch_music_info_widget.dart';
import 'package:pocket_pose/ui/widget/stage/stage_catch_progressbar_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class PoPoCatchView extends StatefulWidget {
  const PoPoCatchView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PoPoCatchViewState();
}

class _PoPoCatchViewState extends State<PoPoCatchView> {
  int _milliseconds = 0;
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;

  @override
  Widget build(BuildContext context) {
    print("mmm catch rebuild");

    _onMidEnter();

    var isReCatch = context.select<SocketStageProviderImpl, bool>(
        (provider) => provider.isReCatch);

    // 캐치 재진행 토스트
    if (isReCatch) {
      _socketStageProvider.setIsReCatch(false);
      Fluttertoast.showToast(
        msg: "캐치를 아무도 안 했어요...😢",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
              // 노래 정보: 제목 + 가수 이름
              Selector<SocketStageProviderImpl, StageMusicData?>(
                  selector: (context, socketProvider) =>
                      socketProvider.catchMusicData,
                  shouldRebuild: (prev, next) {
                    return true;
                  },
                  builder: (context, catchMusicData, child) {
                    return StageCatchMusicInfoWidget(
                        musicInfo:
                            '${catchMusicData?.singer} - ${catchMusicData?.title}',
                        milliseconds: _milliseconds);
                  }),
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
              Stack(
                children: [
                  StageCatchProgressbarWidget(milliseconds: _milliseconds),
                  _buildCatchButton(),
                ],
              ),
            ],
          ),
        ),
        const Flexible(flex: 1, child: SizedBox(height: 60.0 + 150.0)),
      ],
    );
  }

  Center _buildCatchButton() {
    return Center(
      child: InkWell(
        onTap: () {
          _playClickSound();
          _stageProvider.getStageCatch();
        },
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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

  void _onMidEnter() {
    var isCatchMidEnter = context.select<SocketStageProviderImpl, bool>(
        (provider) => provider.isCatchMidEnter);
    if (isCatchMidEnter) {
      _socketStageProvider.setIsCatchMidEnter(false);
      // 중간임장인 경우
      if (_stageProvider.stageCurTime != null) {
        // 중간 입장한 초부터 시작
        setState(() {
          _milliseconds = (_stageProvider.stageCurTime! / 1000000).round();
        });
        _stageProvider.setStageCurSecondNULL();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    AudioPlayerUtil().stop();

    _stageProvider = Provider.of<StageProviderImpl>(context, listen: false);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);
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
