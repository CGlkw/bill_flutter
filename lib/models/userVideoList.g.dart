// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userVideoList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVideoList _$UserVideoListFromJson(Map<String, dynamic> json) {
  return UserVideoList()
    ..mv_id = json['mv_id'] as String
    ..mu_id = json['mu_id'] as String
    ..mv_title = json['mv_title'] as String
    ..mv_img_url = json['mv_img_url'] as String
    ..mv_play_url = json['mv_play_url'] as String
    ..mv_play_width = json['mv_play_width'] as String
    ..mv_play_height = json['mv_play_height'] as String
    ..mv_read = json['mv_read'] as String
    ..mv_like = json['mv_like'] as String
    ..mv_status = json['mv_status'] as String
    ..mv_comment = json['mv_comment'] as String
    ..mv_created = json['mv_created'] as String
    ..mv_updated = json['mv_updated'] as String;
}

Map<String, dynamic> _$UserVideoListToJson(UserVideoList instance) =>
    <String, dynamic>{
      'mv_id': instance.mv_id,
      'mu_id': instance.mu_id,
      'mv_title': instance.mv_title,
      'mv_img_url': instance.mv_img_url,
      'mv_play_url': instance.mv_play_url,
      'mv_play_width': instance.mv_play_width,
      'mv_play_height': instance.mv_play_height,
      'mv_read': instance.mv_read,
      'mv_like': instance.mv_like,
      'mv_status': instance.mv_status,
      'mv_comment': instance.mv_comment,
      'mv_created': instance.mv_created,
      'mv_updated': instance.mv_updated
    };
