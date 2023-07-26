import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StageLiveChatListWidget extends StatefulWidget {
  const StageLiveChatListWidget({super.key});

  @override
  State<StageLiveChatListWidget> createState() =>
      _StageLiveChatListWidgetState();
}

class _StageLiveChatListWidgetState extends State<StageLiveChatListWidget> {
  final List<String> _messageList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    //이전 채팅 목록 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messageList.addAll(['a', 'b', 'c', 'd', 'e', 'f', 'g', '1', '2', '3']);
      });
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

  SingleChildScrollView _buildStageChatList(List<String> entries) {
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
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/home_profile_1.jpg',
                        width: 35,
                        height: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'nickname ${entries[index]}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'content ${entries[index]}',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
