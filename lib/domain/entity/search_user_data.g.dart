// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserData _$SearchUserDataFromJson(Map<String, dynamic> json) =>
    SearchUserData(
      user: UserData.fromJson(json),
      introduce: json['introduce'] as String,
    );

Map<String, dynamic> _$SearchUserDataToJson(SearchUserData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'introduce': instance.introduce,
    };
