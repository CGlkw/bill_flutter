// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vedioDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VedioDetail _$VedioDetailFromJson(Map<String, dynamic> json) {
  return VedioDetail()
    ..mv_id = json['mv_id'] as String
    ..mu_id = json['mu_id'] as String
    ..mv_title = json['mv_title'] as String
    ..mv_img_url = json['mv_img_url'] as String
    ..mv_play_url = json['mv_play_url'] as String
    ..mv_play_width = json['mv_play_width'] as String
    ..mv_play_height = json['mv_play_height'] as String
    ..mv_read = json['mv_read'] as String
    ..mv_like = json['mv_like'] as String
    ..mv_comment = json['mv_comment'] as String
    ..mv_created = json['mv_created'] as String
    ..mv_updated = json['mv_updated'] as String
    ..is_attention = json['is_attention'] as num
    ..is_collect = json['is_collect'] as num
    ..mu_email = json['mu_email'] as String
    ..mu_name = json['mu_name'] as String
    ..mu_sex = json['mu_sex'] as String
    ..mu_avatar = json['mu_avatar'] as String
    ..mu_coins = json['mu_coins'] as String
    ..mu_points = json['mu_points'] as String
    ..mu_sign = json['mu_sign'] as String
    ..mu_sign_days = json['mu_sign_days'] as String
    ..mu_device_pass = json['mu_device_pass'] as num
    ..mu_token = json['mu_token'] as String
    ..mu_status = json['mu_status'] as String
    ..mu_vip_type = json['mu_vip_type'] as String
    ..mu_vip_date = json['mu_vip_date'] as String
    ..mu_me_attention_count = json['mu_me_attention_count'] as String
    ..mu_attention_me_count = json['mu_attention_me_count'] as String
    ..mu_isgag = json['mu_isgag'] as String
    ..isSignin = json['isSignin'] as num
    ..level = json['level'] as num
    ..levelName = json['levelName'] as String
    ..is_vip = json['is_vip'] as num
    ..is_play = json['is_play'] as num;
}

Map<String, dynamic> _$VedioDetailToJson(VedioDetail instance) =>
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
      'mv_comment': instance.mv_comment,
      'mv_created': instance.mv_created,
      'mv_updated': instance.mv_updated,
      'is_attention': instance.is_attention,
      'is_collect': instance.is_collect,
      'mu_email': instance.mu_email,
      'mu_name': instance.mu_name,
      'mu_sex': instance.mu_sex,
      'mu_avatar': instance.mu_avatar,
      'mu_coins': instance.mu_coins,
      'mu_points': instance.mu_points,
      'mu_sign': instance.mu_sign,
      'mu_sign_days': instance.mu_sign_days,
      'mu_device_pass': instance.mu_device_pass,
      'mu_token': instance.mu_token,
      'mu_status': instance.mu_status,
      'mu_vip_type': instance.mu_vip_type,
      'mu_vip_date': instance.mu_vip_date,
      'mu_me_attention_count': instance.mu_me_attention_count,
      'mu_attention_me_count': instance.mu_attention_me_count,
      'mu_isgag': instance.mu_isgag,
      'isSignin': instance.isSignin,
      'level': instance.level,
      'levelName': instance.levelName,
      'is_vip': instance.is_vip,
      'is_play': instance.is_play
    };
