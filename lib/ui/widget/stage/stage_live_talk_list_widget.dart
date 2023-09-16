import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/stage_talk_message_request.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_talk_provider_impl.dart';
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
  late StageTalkProviderImpl _talkProvider;
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;
  var _page = 1;

  @override
  void initState() {
    super.initState();
    _talkProvider = Provider.of<StageTalkProviderImpl>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    _stageProvider.talkList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<StageProviderImpl, List<StageTalkListItem>>(
        selector: (_, stageProvider) => stageProvider.talkList,
        builder: (context, talkList, _) {
          return _buildStageChatList(talkList);
        });
  }

  Widget _buildStageChatList(List<StageTalkListItem> entries) {
    return Selector<SocketStageProviderImpl, StageTalkListItem?>(
        selector: (context, socketProvider) => socketProvider.talk,
        shouldRebuild: (prev, next) {
          return prev != next;
        },
        builder: (context, talk, child) {
          if (talk != null) {
            _stageProvider.addTalk(talk);
            _socketStageProvider.setTalk(null);
          }
          return Container(
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
          );
        });
  }

  _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      var response = await _talkProvider
          .getTalkMessages(StageTalkMessageRequest(page: _page, size: 10));
      _page++;
      var talkList = response.data.messages ?? [];

      setState(() {
        for (var element in talkList) {
          _stageProvider.talkList.add(element);
        }
      });
    }
  }
}
