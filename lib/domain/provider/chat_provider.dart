import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/chat_room_request.dart';
import 'package:pocket_pose/data/entity/response/chat_room_list_response.dart';
import 'package:pocket_pose/data/entity/response/chat_room_response.dart';

abstract class ChatProvider {
  Future<BaseResponse<ChatRoomResponse>> poseChatRoom(ChatRoomRequest request);
  Future<BaseResponse<ChatRoomListResponse>> getChatRoomList();
}
