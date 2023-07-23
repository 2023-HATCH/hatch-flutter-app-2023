import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';

part 'chat_detail_list_response.g.dart';

@JsonSerializable()
class ChatDetailListResponse {
  int pageNum;
  int size;
  List<ChatDetailListItem> messeges;

  ChatDetailListResponse({
    required this.pageNum,
    required this.size,
    required this.messeges,
  });

  factory ChatDetailListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDetailListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDetailListResponseToJson(this);
}
