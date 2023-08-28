import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/data/remote/provider/search_provider.dart';
import 'package:provider/provider.dart';

import '../../../config/app_color.dart';

class SearchTextFieldWidget extends StatefulWidget {
  const SearchTextFieldWidget({
    Key? key,
    required Function setScreen,
  })  : _setScreen = setScreen,
        super(key: key);

  final Function _setScreen;

  @override
  State<StatefulWidget> createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  final TextEditingController _textController = TextEditingController();
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();

    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
  }

  Future<bool> getTags() async {
    return await _searchProvider.getTags();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getTags(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_searchProvider.tagResponse != null) {
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
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: _textController,
                                    decoration: InputDecoration(
                                      hintText: '계정 또는 태그로 검색하세요',
                                      hintStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      labelStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0),
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
                                      //border: InputBorder.none,
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
                                      if (_textController.text.isNotEmpty) {
                                        widget._setScreen(
                                            true, _textController.text);
                                      } else {
                                        widget._setScreen(
                                            false, _textController.text);
                                        Fluttertoast.showToast(
                                            msg: '검색어를 입력하세요');
                                      }
                                    },
                                  ),
                                  onSuggestionSelected: (suggestion) {
                                    // 🔅 태그 리스트 중 선택 (2/3)
                                    _textController.text = suggestion;
                                    if (_textController.text.isNotEmpty) {
                                      widget._setScreen(
                                          true, _textController.text);
                                    } else {
                                      widget._setScreen(
                                          false, _textController.text);
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
                                        // 🔅 태그 목록에 없는 검색어 선택 (3/3)
                                        if (_textController.text.isNotEmpty) {
                                          widget._setScreen(
                                              true, _textController.text);
                                        } else {
                                          widget._setScreen(
                                              false, _textController.text);
                                          Fluttertoast.showToast(
                                              msg: '검색어를 입력하세요');
                                        }
                                        FocusScope.of(context).unfocus();
                                      },
                                    );
                                  },
                                  suggestionsCallback: (pattern) async {
                                    return _searchProvider.tagResponse!.where(
                                        (item) => item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      leading: const Icon(Icons.tag_rounded),
                                      title: Text(
                                        suggestion,
                                        style: TextStyle(
                                          color: AppColor.grayColor,
                                          fontSize: 14,
                                        ),
                                      ),
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
              // ),
            );
          } else {
            //검색 로딩 인디케이터
            return CircularProgressIndicator(
              color: AppColor.purpleColor,
            );
          }
        } else {
          //검색 로딩 인디케이터
          return CircularProgressIndicator(
            color: AppColor.purpleColor,
          );
        }
      },
    );
  }
}
