import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BillPlayer extends StatefulWidget {

  String url;

  BillPlayer(this.url);

  @override
  _BillPlayerState createState() => _BillPlayerState();
}

class _BillPlayerState extends State<BillPlayer> {

 VideoPlayerController _controller;
    bool _isPlaying = false;

    num position =0;

    @override
    void initState() {
        super.initState();
        _controller = VideoPlayerController.network(widget.url)
        // 播放状态
        ..addListener(() {
            final bool isPlaying = _controller.value.isPlaying;
            if (isPlaying != _isPlaying) {
                setState(() { _isPlaying = isPlaying; });
            }
            _controller.position.then((value) => 
              position = value.inMilliseconds
            );
        })
        // 在初始化完成后必须更新界面
        ..initialize().then((_) {
            setState(() {});
        });
    }

    @override
    Widget build(BuildContext context) {
        return Column(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            _controller.value.initialized
            // 加载成功
            ? new AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
            ) : new Container(),
            Row(
              children:[
                IconButton(
                  onPressed: _controller.value.isPlaying
                        ? _controller.pause
                        : _controller.play,
                  icon: new Icon(
                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                )
              ]
            )
          ],
        );   
    }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}