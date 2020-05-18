

import 'package:bill/models/index.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget{

  final String mvId;

  Player(this.mvId);

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player>{
  VideoPlayerController _controller ;
    bool _isPlaying = false;
    String url = '';
    VedioDetail detail = VedioDetail();


    @override
    void initState() {
        super.initState();
        HostListService().getDetail(widget.mvId).then((value) => {
            
            setState(() {
              detail = value;
            }),
            url = value.mv_play_url,
            _controller = VideoPlayerController.network(this.url)
            // 播放状态
            ..addListener(() {
                print(url);
                final bool isPlaying = _controller.value.isPlaying;
                if (isPlaying != _isPlaying) {
                    setState(() { _isPlaying = isPlaying; });
                }
            })
            
            // 在初始化完成后必须更新界面
            ..initialize().then((_) {
                setState(() {});
            })
       
        });
        
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Bill Add')
          ),
          body: new Center(
          child: _controller != null && _controller.value.initialized
            // 加载成功
            ? new AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
            ) : new Container(
              child: detail.mv_img_url != null ?CachedNetworkImage(
                imageUrl: detail.mv_img_url,
              ) : null
            ),
          ),
          floatingActionButton: new FloatingActionButton(
              onPressed: _controller != null ? _controller.value.isPlaying
                  ? _controller.pause
                  : _controller.play : null,
              child: _controller != null ? new Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ) : new Container(),
          ),           
        );
    }
    
    @override
  void dispose() {
    if(_controller != null){
      _controller.pause();
    }
    super.dispose();
  }
}