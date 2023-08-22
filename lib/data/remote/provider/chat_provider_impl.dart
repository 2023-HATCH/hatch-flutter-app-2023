import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/request/chat_room_request.dart';
import 'package:pocket_pose/data/entity/response/chat_detail_list_response.dart';
import 'package:pocket_pose/data/entity/response/chat_room_list_response.dart';
import 'package:pocket_pose/data/entity/response/chat_room_response.dart';
import 'package:pocket_pose/data/remote/repository/chat_repository_impl.dart';
import 'package:pocket_pose/domain/entity/chat_room_list_item.dart';
import 'package:pocket_pose/domain/provider/chat_provider.dart';

class ChatProviderImpl extends ChangeNotifier implements ChatProvider {
  final ChatRepositoryImpl _chatRepository = ChatRepositoryImpl();

  final List<ChatRoomListItem> _chatRooms = [];

  List<ChatRoomListItem> get chatRooms => _chatRooms;

  setChatRooms(List<ChatRoomListItem> list) {
    _chatRooms.addAll(list);
    notifyListeners();
  }

  @override
  Future<BaseResponse<ChatRoomResponse>> putChatRoom(
      ChatRoomRequest request) async {
    return await _chatRepository.putChatRoom(request);
  }

  @override
  Future<BaseResponse<ChatRoomListResponse>> getChatRoomList() async {
    var responseJson = await _chatRepository.getChatRoomList();

    setChatRooms(responseJson.data.chatRooms);

    return responseJson;
  }

  @override
  Future<BaseResponse<ChatDetailListResponse>> getChatDetailList(
      String chatRoomId, int page) async {
    return await _chatRepository.getChatDetailList(chatRoomId, page);
  }
}
