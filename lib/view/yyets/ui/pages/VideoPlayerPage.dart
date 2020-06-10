import 'dart:async';
import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:bill/view/yyets/ui/widgets/visibility.dart';
import 'package:bill/view/yyets/ui/widgets/wrapped_material_dialog.dart';
import 'package:bill/view/yyets/utils/mysp.dart';
import 'package:bill/view/yyets/utils/times.dart';
import 'package:bill/view/yyets/utils/toast.dart';
import 'package:fyyets_dl2/RRResManager.dart';
import 'package:screen/screen.dart';
import 'package:volume_watcher/volume_watcher.dart';

class VideoPlayerPage extends StatefulWidget {
  final String resUri;
  final String title;
  final int type;

  static const int TYPE_FILE = 0;
  static const int TYPE_NETWORK = 1;

  VideoPlayerPage(Map data)
      : this.resUri = data['uri'],
        this.title = data['title'],
        this.type = data['type'] ?? 0;

  @override
  State createState() => _PageState();
}

const DISPLAY_MODE_KEEP_ASPECT = 0;
const DISPLAY_MODE_COVERED = 1;

class _PageState extends State<VideoPlayerPage> {
  IjkMediaController _controller = IjkMediaController();

  //滑动调节进度结束后是否继续播放状态
  bool _cacheStatus;

  //视频总长度
  int _totalLength = 0;

  double get playProgress => _totalLength == 0 ? 0.0 : _playPos / _totalLength;

  //视频当前进度
  int _playPos = 0;
  var aspectRatio = 0.0;

  //高度
  double panelHeight = 60;

  //进度调节块显隐标志
  bool _centerProgressbarVisibility = false;

  //亮度指示条显隐标志
  bool _screenBrightnessPanelVisibility = false;

  //音量指示条显隐标志
  bool _volumePanelVisibility = false;

  //格式化当前进度时间
  String get _playTime => formatLength(_playPos);

  //监听进度 上次保存进度时间
  int _lastSavePos = 0;

  //屏幕亮度
  double _screenBrightness = 0;

  //音量百分比
  double _volumePercentage = 0;

  //最大音量
  int _maxVolume = 0;

  //倍速
  double _speed = null;

  //显示模式 [DISPLAY_MODE_KEEP_PROPORTION] [DISPLAY_MODE_COVERED]
  int _displayMode;

  Future<void> initPlatformState() async {
    num initVolume = await VolumeWatcher.getCurrentVolume;
    num maxVolume = await VolumeWatcher.getMaxVolume;

    if (!mounted) return;
    this._volumePercentage = initVolume / maxVolume;
    this._maxVolume = maxVolume;
    print("音量：${initVolume}/${maxVolume}");
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
    //横屏
    Screen.brightness.then((value) {
      _screenBrightness = value;
      print("screenBrightness: $value");
    });
    AutoOrientation.landscapeAutoMode();
    //隐藏状态栏 导航栏
    SystemChrome.setEnabledSystemUIOverlays([]);

    if (widget.type == VideoPlayerPage.TYPE_FILE) {
      _controller.setFileDataSource(File(widget.resUri), autoPlay: true);
    } else {
      _controller.setNetworkDataSource(widget.resUri, autoPlay: true);
    }
//
//    _controller.play().catchError((e) {
//      showUnSupportDialog(e);
//    });
    Future.delayed(Duration(milliseconds: 300), () async {
      //上次播放进度
      var sp = await MySp;
      _displayMode = sp.get("display_mode", DISPLAY_MODE_KEEP_ASPECT);
      int pos = sp.get("pos_${widget.resUri.hashCode}", 0);
      print("seek to $pos");

      var vi = await _controller.getVideoInfo();
      aspectRatio = vi.ratio;
      print("VideoInfo $vi");

      _totalLength = ((vi.duration ?? 0) * 1000).toInt();
      //结尾
      if (_totalLength - pos < 3000 || pos == 0) {
        //todo 播放起始位置 跳过广告
        pos = 0;
      }
      //后退2s
      if (pos > 10000) {
        pos -= 2000;
      }
      _controller.seekTo(pos / 1000).whenComplete(() {
        setState(() {
          _playPos = pos;
          _controller.play();
        });
      });
      startDelayHidePanel();
      Screen.keepOn(true);
    }).catchError((e) {
      showUnSupportDialog(e);
      print("errrr:==>  $e");
      toast(e);
    });

    timer = Timer.periodic(Duration(milliseconds: 800), (t) async {
      //未在调节进度时
      if (!mounted || _centerProgressbarVisibility || !_controller.isPlaying) {
        return;
      }
      var vi = await _controller.getVideoInfo();
      int now = DateTime.now().millisecondsSinceEpoch;
      _totalLength = (vi.duration * 1000).toInt();
      int pos = (vi.currentPosition * 1000).toInt();
      if (pos >= _totalLength) {
        onPlayFinished();
      }

      if (now - _lastSavePos > 800 && pos > 0) {
        _lastSavePos = now;
        MySp.then((sp) {
          sp.set("pos_${widget.resUri.hashCode}", pos);
        });
      }
      _playPos = pos;
      //更新进度条
      if (_playControlVisibility && mounted) {
        setState(() {});
      }
    });
  }

  Timer timer;

  void onPlayFinished() {
//    Navigator.pop(context);
    setState(() {});
  }

  void togglePlayStatus() {
    startDelayHidePanel();
    setState(() {
      if (_controller.isPlaying) {
        _controller.pause();
        Screen.keepOn(false);
      } else {
        _controller.play();
        Screen.keepOn(true);
      }
    });
  }

  bool _playControlVisibility = true;

  void toggleControllerPanel() {
    setState(() {
      _playControlVisibility = !_playControlVisibility;
      startDelayHidePanel();
    });
  }

  Timer delayHideTimer;

  void startDelayHidePanel() {
    delayHideTimer?.cancel();
    delayHideTimer?.cancel();
    delayHideTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _playControlVisibility = false;
        });
      }
    });
  }

  int _startDragPos = 0;
  int verticalDragAction = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onVerticalDragStart: (DragStartDetails d) async {
                var size = MediaQuery.of(context).size;
                print("screen size: ${size.width}");
                double boundary = size.height * 0.2;
                var dy = d.globalPosition.dy;
                //上下边缘不处理
                if (dy < boundary || dy > size.height - boundary) {
                  verticalDragAction = -1;
                  return;
                }
                //确定 左右
                if (d.localPosition.dx < size.width / 2) {
                  print("左侧");
                  setState(() {
                    _screenBrightnessPanelVisibility = true;
                  });
                  verticalDragAction = 0;
                } else {
                  print("右侧");
                  //防止 手动按键调节；重新获取音量
                  num initVolume = await VolumeWatcher.getCurrentVolume;
                  num maxVolume = await VolumeWatcher.getMaxVolume;
                  this._volumePercentage = initVolume / maxVolume;
                  setState(() {
                    _volumePanelVisibility = true;
                  });
                  verticalDragAction = 1;
                }
              },
              onVerticalDragUpdate: (DragUpdateDetails d) {
                if (verticalDragAction == -1) {
                  return;
                }
                var size = MediaQuery.of(context).size;
                double dy = d.delta.dy;
                double dyPercent = (dy / size.height * 1.5);
                if (dy == 0) {
                  return;
                }
                print(dy);
                if (verticalDragAction == 0) {
                  _screenBrightness -= dyPercent;
                  if (_screenBrightness < 0) {
                    _screenBrightness = 0;
                  } else if (_screenBrightness > 1) {
                    _screenBrightness = 1;
                  }
                  print("_screenBrightness $_screenBrightness");
                  setState(() {
                    Screen.setBrightness(_screenBrightness);
                  });
                } else {
                  _volumePercentage -= dyPercent;

                  if (_volumePercentage < 0) {
                    _volumePercentage = 0;
                  } else if (_volumePercentage > 1) {
                    _volumePercentage = 1;
                  }
                  setState(() {
                    VolumeWatcher.setVolume(_maxVolume * _volumePercentage);
                  });
                  print("_volumePercentage: $_volumePercentage");
                }
              },
              onVerticalDragEnd: (DragEndDetails d) {
                if (verticalDragAction == -1) {
                  return;
                }
                if (verticalDragAction == 0) {
                  setState(() {
                    _screenBrightnessPanelVisibility = false;
                  });
                } else {
                  setState(() {
                    _volumePanelVisibility = false;
                  });
                }
                print("onVerticalDragEnd");
              },
              onHorizontalDragStart: (DragStartDetails d) {
                //todo 利用onHorizontalDragDown拦截?
                var size = MediaQuery.of(context).size;
                double boundary = size.width * 0.1;
                var x = d.globalPosition.dx;
                //左右边缘不处理
                if (x < boundary || x > size.width - boundary) {
                  return;
                }
                _startDragPos = _playPos;
                print("onHorizontalDragStart  ${_playPos}");
                _cacheStatus = _controller.isPlaying;
                setState(() {
                  _centerProgressbarVisibility = true;
                  _controller.pause();
                });
              },
              onHorizontalDragEnd: (DragEndDetails d) {
                if (!_centerProgressbarVisibility) {
                  return;
                }
                startDelayHidePanel();
                print("DragEndDetails  ${_playPos}");
                setState(() {
                  _centerProgressbarVisibility = false;
                  _controller.seekTo(_playPos / 1000).whenComplete(() {
                    if (_cacheStatus) {
                      setState(() {
                        _controller.play();
                      });
                    }
                  });
                });
              },
              onHorizontalDragUpdate: (DragUpdateDetails d) {
                if (!_centerProgressbarVisibility) {
                  return;
                }
                double dx = d.delta.dx;
                if (dx == 0.0) return;
                _playPos += (d.delta.dx * 500).toInt();
                print("$dx,  ${_playPos}");

                if (_playPos > _totalLength) {
                  print("_playPos > _totalLength");
                  _playPos = _totalLength;
                } else if (_playPos < 0) {
                  _playPos = 0;
                }
                setState(() {});
              },
              onDoubleTap: togglePlayStatus,
              onTap: toggleControllerPanel,
              child: _displayMode == 0
                  ? AspectRatio(
                      aspectRatio: aspectRatio,
                      child: IjkPlayer(
                        controllerWidgetBuilder: (a) => Container(),
                        statusWidgetBuilder: (a, b, v) => Container(),
                        mediaController: _controller,
                      ),
                    )
                  : IjkPlayer(
                      controllerWidgetBuilder: (a) => Container(),
                      statusWidgetBuilder: (a, b, v) => Container(),
                      mediaController: _controller,
                    ),
            ),
          ),
          _StatusPanel(
            _screenBrightnessPanelVisibility,
            _screenBrightness,
            Icon(
              _screenBrightness == 0
                  ? Icons.brightness_low
                  : Icons.brightness_high,
              color: Colors.white,
            ),
            Alignment.centerRight,
            60,
          ),
          _StatusPanel(
            _volumePanelVisibility,
            _volumePercentage,
            Icon(
              _volumePercentage == 0 ? Icons.volume_mute : Icons.volume_up,
              color: Colors.white,
            ),
            Alignment.centerLeft,
            -60,
          ),
          Offstage(
            offstage: !_centerProgressbarVisibility,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                height: 70,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.5),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          value: playProgress,
                        ),
                      ),
                    ),
                    Container(height: 12),
                    Text(
                      () {
                        int offSecs = (_playPos - _startDragPos) ~/ 1000;
                        return _playTime +
                            "\t ${offSecs > 0 ? "+" : ""}${offSecs}s";
                      }(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
              ),
            ),
          ),
          Visible(
            visible: _playControlVisibility,
            childBuilder: () => Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                height: panelHeight,
                alignment: Alignment.centerLeft,
                child: AppBar(
                  title: Text(
                    widget.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.aspect_ratio,
                        color: _displayMode == DISPLAY_MODE_KEEP_ASPECT
                            ? Colors.blueAccent
                            : Colors.white,
                      ),
                      onPressed: () =>
                          changeDisplayMode(DISPLAY_MODE_KEEP_ASPECT),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings_overscan,
                        color: _displayMode == DISPLAY_MODE_COVERED
                            ? Colors.blueAccent
                            : Colors.white,
                      ),
                      onPressed: () => changeDisplayMode(DISPLAY_MODE_COVERED),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: BackButton(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Visible(
            visible: _playControlVisibility,
            childBuilder: () => Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )),
                width: double.infinity,
                height: panelHeight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: togglePlayStatus,
                        icon: Icon(
                          _controller.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _playTime,
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.white24,
                          min: 0.0,
                          label: _playTime,
                          max: _totalLength.toDouble(),
                          value: _playPos > _totalLength
                              ? _totalLength.toDouble()
                              : _playPos.toDouble(),
                          onChangeStart: (d) {
                            _startDragPos = _playPos;
                            _cacheStatus = _controller.isPlaying;
                            print("onChangeStart:  $_cacheStatus");
                            delayHideTimer?.cancel();
                            setState(() {
                              _centerProgressbarVisibility = true;
                              _controller.pause();
                            });
                          },
                          onChangeEnd: (p) {
                            print("onChangeEnd:  $_cacheStatus");
                            startDelayHidePanel();
                            _playPos = p.toInt();
                            setState(() {
                              _centerProgressbarVisibility = false;
                              _controller.seekTo(p / 1000).whenComplete(() {
                                if (_cacheStatus) {
                                  _controller.play();
                                }
                              });
                            });
                          },
                          onChanged: (p) =>
                              setState(() => _playPos = p.toInt()),
                        ),
                      ),
                      InkResponse(
                        child: PopupMenuButton(
                          onSelected: (v) {
                            setState(() {
                              _speed = v;
                              _controller.setSpeed(v);
                            });
                          },
                          itemBuilder: (BuildContext context) => _speeds
                              .map((e) => PopupMenuItem(
                                  child: Text(
                                    "${e}X",
                                    style: e == (_speed ?? 1.0)
                                        ? TextStyle(
                                            color:
                                                Theme.of(context).accentColor)
                                        : null,
                                  ),
                                  value: e))
                              .toList(),
                          child: Text(
                            _speed == null ? "倍速" : "${_speed}X",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(width: 10),
                      Text(
                        formatLength(_totalLength),
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(width: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  @override
  void dispose() {
    timer?.cancel();
    _controller.pause();
    _controller.dispose();
    AutoOrientation.fullAutoMode();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    Screen.keepOn(false);
    Screen.setBrightness(-1);

    super.dispose();
  }

  void changeDisplayMode(int mode) {
    startDelayHidePanel();
    if (_displayMode == mode) {
      return;
    }
    MySp.then((sp) => sp.set("display_mode", mode));
    setState(() {
      _displayMode = mode;
    });
  }

  void showUnSupportDialog(e) {
    showDialog(
      context: context,
      builder: (c) => WrappedMaterialDialog(
        c,
        title: Text("不支持该视频，$e"),
        content: Text("请使用外部播放器播放"),
        actions: [
          FlatButton(
            child: Text("使用外部播放器"),
            onPressed: () {
              RRResManager.playByExternal(widget.resUri);
              Navigator.pop(c);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("退出"),
            onPressed: () {
              Navigator.pop(c);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final bool visibility;
  final double progress;
  final Icon icon;

  final AlignmentGeometry alignment;
  final double offsetY;

  _StatusPanel(
      this.visibility, this.progress, this.icon, this.alignment, this.offsetY);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !visibility,
      child: Align(
        alignment: alignment,
        child: Transform.translate(
          offset: Offset(offsetY, 0),
          child: Container(
            height: 20,
            width: 200,
            child: Transform.rotate(
              angle: -3.1415926 / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TODO 优化 垂直进度条
                  Transform.rotate(
                    child: icon,
                    angle: 3.1415926 / 2,
                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    height: 5,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2.5),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
