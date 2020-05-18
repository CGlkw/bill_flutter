import 'package:json_annotation/json_annotation.dart';

part 'vedioList.g.dart';

@JsonSerializable()
class VedioList {
    VedioList();

    String mv_id;
    String mu_id;
    String mv_title;
    String mv_img_url;
    String mv_play_url;
    String mv_play_width;
    String mv_play_height;
    String mv_like;
    String mv_comment;
    String mv_created;
    String mu_avatar;
    String mu_name;
    num is_cat_ads;
    
    factory VedioList.fromJson(Map<String,dynamic> json) => _$VedioListFromJson(json);
    Map<String, dynamic> toJson() => _$VedioListToJson(this);
}
