import 'package:flutter/material.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';
import 'package:pocket_pose/ui/widget/stage/talk_list_item_widget.dart';
import 'package:provider/provider.dart';

class StageLiveTalkListWidget extends StatefulWidget {
  const StageLiveTalkListWidget({super.key});

  @override
  State<StageLiveTalkListWidget> createState() =>
      _StageLiveTalkListWidgetState();
}

class _StageLiveTalkListWidgetState extends State<StageLiveTalkListWidget> {
  final ScrollController _scrollController = ScrollController();
  late StageProviderImpl _provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<StageProviderImpl>(context, listen: true);

    return _buildStageChatList(_provider.talkList);
  }

  SingleChildScrollView _buildStageChatList(List<StageTalkListItem> entries) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0001, 0.25],
          ),
        ),
        height: 150,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.center,
              end: Alignment.topCenter,
              colors: [Colors.white, Colors.white.withOpacity(0.02)],
              stops: const [0.2, 1],
            ).createShader(bounds);
          },
          child: ListView.separated(
              reverse: true,
              shrinkWrap: true,
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              itemCount: entries.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (BuildContext context, int index) {
                return TalkListItemWidget(talk: entries[index]);
              }),
        ),
      ),
    );
  }
}
