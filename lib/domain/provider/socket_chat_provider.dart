import 'package:pocket_pose/data/entity/socket_request/send_chat_request.dart';

abstract class SocketChatProvider {
  void connectWebSocket();
  void onSubscribe(String chatRoomId);
  void sendMessage(SendChatRequest request);
}
