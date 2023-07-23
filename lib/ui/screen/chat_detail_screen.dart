import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';

class ChatDetailScreen extends StatefulWidget {
  // final _io.Socket socket;

  const ChatDetailScreen({
    Key? key,
    // required this.socket,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  //새로운 채팅 올때마다 추가하기위한 StreamController
  // final StreamController<LiveChatObject> _streamController =
  //     StreamController<LiveChatObject>();

  //메세지 리스트 (노출할 채팅목록이 있는 리스트)
  final List<ChatDetailListItem> _messageList = [];

  //채팅리스트 scrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    //이전 채팅 목록 가져오기
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   widget.socket.emit('chats');
    //   widget.socket.on('CHATS', (data) {
    //     Iterable list = data['CA'];

    //     //Json정보를 받아올 채팅 구조(LiveChatObject)의 리스트형태로 변환
    //     var beforeChats =
    //         list.map((i) => LiveChatObject.fromJson(i)).toList();

    //     setState(() {
    //       //받아온 이전 채팅목록을 messageList에 추가
    //       beforeChats.forEach((chatData) {
    //           _messageList.add(chatData);

    //       });
    //     });
    //   });
    // });

    //새로운 채팅 올때마다 messageList에 추가
    // widget.socket.on('MSSG', (data) {
    //   _streamController.sink.add(LiveChatObject.fromJson(data));
    //   setState(() {
    //       _messageList.add(LiveChatObject.fromJson(data));

    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    // _streamController.close();
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

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: AppColor.purpleColor3,
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
        height: 170,
        padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          controller: _scrollController,
          itemCount: _messageList.length,
          itemBuilder: (BuildContext context, int index) {
            return _messageList[index].sender.nickname != "pochako"
                ? const Text("내가 보낸 거")
                : const Text("포차코가 보낸 거");
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "pochako",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: AppColor.purpleColor3,
      elevation: 0.0,
      leading: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          'assets/icons/ic_back.png',
        ),
      ),
    );
  }
}
