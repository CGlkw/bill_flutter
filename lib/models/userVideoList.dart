import 'package:json_annotation/json_annotation.dart';

part 'userVideoList.g.dart';

@JsonSerializable()
class UserVideoList {
    UserVideoList();

    String mv_id;
    String mu_id;
    String mv_title;
    String mv_img_url;
    String mv_play_url;
    String mv_play_width;
    String mv_play_height;
    String mv_read;
    String mv_like;
    String mv_status;
    String mv_comment;
    String mv_created;
    String mv_updated;
    
    factory UserVideoList.fromJson(Map<String,dynamic> json) => _$UserVideoListFromJson(json);
    Map<String, dynamic> toJson() => _$UserVideoListToJson(this);
    @override
    String toString() {
        return this.toJson().toString();
    }
}
