import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
    Comment();

    String mc_id;
    String mv_id;
    String mc_parent_id;
    String mu_id;
    String mc_reply_uid;
    String mc_text;
    String mc_praises;
    String mc_reply_count;
    String mc_floor;
    String mc_created;
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
    List<Comment> reply;
    String replyUserName;
    num replyUserIsAuthor;
    num isAuthor;
    
    factory Comment.fromJson(Map<String,dynamic> json) => _$CommentFromJson(json);
    Map<String, dynamic> toJson() => _$CommentToJson(this);

    @override
  String toString() {
    return this.toJson().toString();
  }
}
