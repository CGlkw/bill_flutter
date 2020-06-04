// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'momiUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MomiUser _$MomiUserFromJson(Map<String, dynamic> json) {
  return MomiUser()
    ..mu_id = json['mu_id'] as String
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
    ..play_count = json['play_count'] as num
    ..is_attention = json['is_attention'] as num
    ..isToken = json['isToken'] as num
    ..unReadCount = json['unReadCount'] as num
    ..video_list =  (json['video_list'] as List)
          ?.map((e) =>
      e == null ? null : UserVideoList.fromJson(e as Map<String, dynamic>))
          ?.toList();
}

Map<String, dynamic> _$MomiUserToJson(MomiUser instance) => <String, dynamic>{
      'mu_id': instance.mu_id,
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
      'play_count': instance.play_count,
      'is_attention': instance.is_attention,
      'isToken': instance.isToken,
      'unReadCount': instance.unReadCount,
      'video_list': instance.video_list
    };
