import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class BillPlayer extends StatefulWidget {

  String url;
  String mv_play_width;
  String mv_play_height;

  BillPlayer(this.url,this.mv_play_width,this.mv_play_height);

  @override
  _BillPlayerState createState() => _BillPlayerState();
}

class _BillPlayerState extends State<BillPlayer> {

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
      aspectRatio: double.parse(widget.mv_play_width)  / double.parse(widget.mv_play_height),
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
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}