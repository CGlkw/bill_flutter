// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment()
    ..mc_id = json['mc_id'] as String
    ..mv_id = json['mv_id'] as String
    ..mc_parent_id = json['mc_parent_id'] as String
    ..mu_id = json['mu_id'] as String
    ..mc_reply_uid = json['mc_reply_uid'].toString()
    ..mc_text = json['mc_text'] as String
    ..mc_praises = json['mc_praises'] as String
    ..mc_reply_count = json['mc_reply_count'] as String
    ..mc_floor = json['mc_floor'] as String
    ..mc_created = json['mc_created'] as String
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
    ..replyUserName = json['replyUserName'] as String
    ..replyUserIsAuthor = json['replyUserIsAuthor'] as num
    ..isAuthor = json['isAuthor'] as num;
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'mc_id': instance.mc_id,
      'mv_id': instance.mv_id,
      'mc_parent_id': instance.mc_parent_id,
      'mu_id': instance.mu_id,
      'mc_reply_uid': instance.mc_reply_uid,
      'mc_text': instance.mc_text,
      'mc_praises': instance.mc_praises,
      'mc_reply_count': instance.mc_reply_count,
      'mc_floor': instance.mc_floor,
      'mc_created': instance.mc_created,
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
      'reply': instance.reply,
      'replyUserName': instance.replyUserName,
      'replyUserIsAuthor': instance.replyUserIsAuthor,
      'isAuthor': instance.isAuthor
    };
