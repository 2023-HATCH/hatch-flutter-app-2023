// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileEditRequest _$ProfileEditRequestFromJson(Map<String, dynamic> json) =>
    ProfileEditRequest(
      introduce: json['introduce'] as String,
      instagramId: json['instagramId'] as String,
      twitterId: json['twitterId'] as String,
    );

Map<String, dynamic> _$ProfileEditRequestToJson(ProfileEditRequest instance) =>
    <String, dynamic>{
      'introduce': instance.introduce,
      'instagramId': instance.instagramId,
      'twitterId': instance.twitterId,
    };
