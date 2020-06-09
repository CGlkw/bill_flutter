import 'package:bill/models/userVideoList.dart';
import 'package:json_annotation/json_annotation.dart';

part 'momiUser.g.dart';

@JsonSerializable()
class MomiUser {
    MomiUser();

    String mu_id;
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
    num play_count;
    num is_attention;
    num isToken;
    num unReadCount;
    List<UserVideoList> video_list;
    
    factory MomiUser.fromJson(Map<String,dynamic> json) => _$MomiUserFromJson(json);
    Map<String, dynamic> toJson() => _$MomiUserToJson(this);

    @override
  String toString() {
    return this.toJson().toString();
  }
}
