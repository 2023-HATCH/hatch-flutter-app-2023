import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/data/entity/base_response.dart';
import 'package:pocket_pose/data/entity/response/chat_search_user_list_response.dart';
import 'package:pocket_pose/data/remote/provider/chat_provider_impl.dart';
import 'package:pocket_pose/ui/loader/search_textfield_loader.dart';
import 'package:pocket_pose/ui/widget/chat/chat_search_user_list_item_widget.dart';
import 'package:provider/provider.dart';

import '../../../config/app_color.dart';

class ChatSearchUserTextFieldWidget extends StatefulWidget {
  const ChatSearchUserTextFieldWidget(
      {Key? key, required this.showChatDetailScreen})
      : super(key: key);
  final Function showChatDetailScreen;

  @override
  State<StatefulWidget> createState() => _ChatSearchUserTextFieldWidgetState();
}

class _ChatSearchUserTextFieldWidgetState
    extends State<ChatSearchUserTextFieldWidget> {
  final TextEditingController _textController = TextEditingController();
  late ChatProviderImpl _chatProvider;

  @override
  void initState() {
    super.initState();

    _chatProvider = Provider.of<ChatProviderImpl>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BaseResponse<ChatSearchUserListResponse>>(
      future: _chatProvider.getChatSearchUserList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              const SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(left: 18)),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                              height: 35,
                              child: TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _textController,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    hintText: '닉네임을 검색하여 채팅을 시작해보세요.',
                                    hintStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        _textController.clear();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        child: Icon(
                                          Icons.clear_rounded,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      child: Icon(
                                        Icons.search_rounded,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppColor.purpleColor,
                                      ),
                                    ),
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppColor.grayColor4,
                                      ),
                                    ),
                                    fillColor: AppColor.grayColor4, // 배경색 설정
                                    filled: true, // 배경색 채우기 활성화
                                  ),
                                  onSubmitted: (value) {
                                    // 🔅 키보드에서 submit (1/3)
                                    if (!_textController.text.isNotEmpty) {
                                      Fluttertoast.showToast(msg: '검색어를 입력하세요');
                                    }
                                  },
                                ),
                                onSuggestionSelected: (suggestion) {
                                  // 🔅 user 리스트 중 선택 (2/3)
                                  if (!_textController.text.isNotEmpty) {
                                    Fluttertoast.showToast(msg: '검색어를 입력하세요');
                                  }
                                },
                                noItemsFoundBuilder: (context) {
                                  return GestureDetector(
                                    child: ListTile(
                                      leading: const Icon(Icons.search),
                                      title: Text(
                                        _textController.text,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      // 🔅 user 목록에 없는 검색어 선택 (3/3)
                                      if (_textController.text.isNotEmpty) {
                                        Fluttertoast.showToast(
                                            msg: '해당 사용자가 없습니다.');
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: '검색어를 입력하세요');
                                      }
                                      FocusScope.of(context).unfocus();
                                    },
                                  );
                                },
                                suggestionsCallback: (pattern) async {
                                  return _chatProvider.userList.where((item) =>
                                      item.nickname.contains(pattern));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ChatSearchUserListItemWidget(
                                    chatUser: suggestion,
                                    showChatDetailScreen:
                                        widget.showChatDetailScreen,
                                  );
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 18)),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          );
        } else {
          return const SearchTextFieldLoader();
        }
      },
    );
  }
}
