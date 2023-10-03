import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/domain/entity/stage_player_info_list_item.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StageResultPlayerInfoWidget extends StatelessWidget {
  const StageResultPlayerInfoWidget(
      {super.key,
      required this.player,
      required this.index,
      required this.playerLength});
  final StagePlayerInfoListItem player;
  final int index;
  final int playerLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: (index == 0)
          //  mvp면 테두리 네온 추가
          ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        for (double i = 1; i < 5; i++)
                          BoxShadow(
                              color: AppColor.yellowColor,
                              blurStyle: BlurStyle.outer,
                              blurRadius: 3 * i)
                      ]),
                  child: _buildPlayerInfoWidget(player, index))
              .animate(
                  delay:
                      (1000 * playerLength - 1000 * (playerLength - index + 1))
                          .ms)
              .shimmer(duration: 1200.ms, color: AppColor.grayColor2)
              .animate(
                  delay:
                      (1000 * playerLength - 1000 * (playerLength - index + 1))
                          .ms)
              .scale(begin: const Offset(0.8, 0.8))
          : _buildPlayerInfoWidget(player, index)
              .animate(
                  delay:
                      (1000 * playerLength - 1000 * (playerLength - index + 1))
                          .ms)
              .shimmer(duration: 1200.ms, color: AppColor.grayColor2)
              .animate(
                  delay:
                      (1000 * playerLength - 1000 * (playerLength - index + 1))
                          .ms)
              .fadeIn(duration: 1200.ms, curve: Curves.fastOutSlowIn)
              .slide(),
    );
  }

  Widget _buildPlayerInfoWidget(StagePlayerInfoListItem player, int index) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: Center(
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SvgPicture.asset(
                    'assets/images/img_stage_result_${index + 1}.svg',
                    width: 44.8,
                    height: 50.4,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 1.2, 6.72),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: (player.player.profileImg == null)
                          ? Image.asset(
                              'assets/images/charactor_popo_default.png',
                              width: 34.72,
                              height: 34.72,
                            )
                          : Image.network(
                              player.player.profileImg!,
                              fit: BoxFit.cover,
                              width: 34.72,
                              height: 34.72,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.purpleColor,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/charactor_popo_default.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      player.player.nickname,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          (player.similarity > -1)
                              ? "🔥 ${(player.similarity * 10000).floor()}"
                              : "점수 없음",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        (player.similarity > -1)
                            ? const Text(
                                " / 10000",
                                style: TextStyle(
                                  fontSize: 6,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : const Text(
                                "",
                                textAlign: TextAlign.end,
                              )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
