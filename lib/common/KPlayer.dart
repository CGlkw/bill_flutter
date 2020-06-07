import 'package:bill/common/KPlayer/src/chewie_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class KPlayer extends StatefulWidget {

  String url;
  double mvPlayWidth;
  double mvPlayHeight;

  KPlayer(this.url,this.mvPlayWidth,this.mvPlayHeight);

  @override
  _KPlayerState createState() => _KPlayerState();
}

class _KPlayerState extends State<KPlayer> with AutomaticKeepAliveClientMixin{

  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    //配置视频地址
    videoPlayerController = VideoPlayerController.network(
        widget.url);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: widget.mvPlayWidth / widget.mvPlayHeight,
      autoPlay: true, //自动播放
      looping: true, //循环播放
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );

  }

  @override
  void dispose() {
    /**
     * 当页面销毁的时候，将视频播放器也销毁
     * 否则，当页面销毁后会继续播放视频！
     */
    print("播放器销毁");
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive => true;
}