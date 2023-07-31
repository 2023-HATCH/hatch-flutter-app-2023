import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_pose/data/entity/request/stage_talk_message_request.dart';
import 'package:pocket_pose/data/remote/provider/stage_talk_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';
import 'package:pocket_pose/ui/widget/stage/talk_list_item_widget.dart';

class StageLiveChatListWidget extends StatefulWidget {
  const StageLiveChatListWidget({super.key});

  @override
  State<StageLiveChatListWidget> createState() =>
      _StageLiveChatListWidgetState();
}

class _StageLiveChatListWidgetState extends State<StageLiveChatListWidget> {
  List<StageTalkListItem> _messageList = [];
  final ScrollController _scrollController = ScrollController();
  final _provider = StageTalkProviderImpl();

  @override
  void initState() {
    super.initState();
    getTalkMessage();
  }

  void getTalkMessage() async {
    var result = await _provider
        .getTalkMessages(StageTalkMessageRequest(page: 0, size: 3));
    setState(() {
      _messageList = result.data.messages ?? [];
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build마다 채팅 스크롤 맨 밑으로
    if (_messageList.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeOut,
        );
      });
    }

    return _buildStageChatList(_messageList);
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
