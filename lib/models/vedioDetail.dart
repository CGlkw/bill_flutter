import 'package:json_annotation/json_annotation.dart';

part 'vedioDetail.g.dart';

@JsonSerializable()
class VedioDetail {
    VedioDetail();

    String mv_id;
    String mu_id;
    String mv_title;
    String mv_img_url;
    String mv_play_url;
    String mv_play_width;
    String mv_play_height;
    String mv_read;
    String mv_like;
    String mv_comment;
    String mv_created;
    String mv_updated;
    num is_attention;
    num is_collect;
    String mu_email;
    String mu_name;
    String mu_sex;
    String mu_avatar;
    String mu_coins;
    String mu_points;
    String mu_sign;
    String mu_sign_days;
    num mu_device_pass;
    String mu_token;
    String mu_status;
    String mu_vip_type;
    String mu_vip_date;
    String mu_me_attention_count;
    String mu_attention_me_count;
    String mu_isgag;
    num isSignin;
    num level;
    String levelName;
    num is_vip;
    num is_play;
    
    factory VedioDetail.fromJson(Map<String,dynamic> json) => _$VedioDetailFromJson(json);
    Map<String, dynamic> toJson() => _$VedioDetailToJson(this);
}
