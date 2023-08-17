import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_pose/data/entity/base_object.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';

part 'chat_detail_list_response.g.dart';

@JsonSerializable()
class ChatDetailListResponse extends BaseObject<ChatDetailListResponse> {
  int page;
  int size;
  List<ChatDetailListItem> messages;

  ChatDetailListResponse({
    required this.page,
    required this.size,
    required this.messages,
  });

  factory ChatDetailListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDetailListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDetailListResponseToJson(this);

  @override
  ChatDetailListResponse fromJson(json) {
    return ChatDetailListResponse.fromJson(json);
  }
}
