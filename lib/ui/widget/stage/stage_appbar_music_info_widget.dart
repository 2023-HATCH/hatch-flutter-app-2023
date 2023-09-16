import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:provider/provider.dart';

class StageAppbarMusicInfoWidget extends StatelessWidget {
  const StageAppbarMusicInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);
    var stageProvider = Provider.of<StageProviderImpl>(context, listen: false);
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_music_note_small.svg',
          ),
          const SizedBox(width: 8.0),
          (socketStageProvider.catchMusicData != null)
              ? Text(
                  '${socketStageProvider.catchMusicData?.singer} - ${socketStageProvider.catchMusicData?.title}',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                )
              : Text(
                  '${stageProvider.music?.singer} - ${stageProvider.music?.title}',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
        ],
      ),
    );
  }
}
