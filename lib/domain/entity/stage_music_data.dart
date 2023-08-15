import 'package:json_annotation/json_annotation.dart';

part 'stage_music_data.g.dart';

@JsonSerializable()
class StageMusicData {
  String musicId;
  String title;
  String singer;
  int length;
  String musicUrl;
  String concept;

  StageMusicData(
      {required this.musicId,
      required this.title,
      required this.singer,
      required this.length,
      required this.musicUrl,
      required this.concept});

  factory StageMusicData.fromJson(Map<String, dynamic> json) =>
      _$StageMusicDataFromJson(json);

  Map<String, dynamic> toJson() => _$StageMusicDataToJson(this);
}
