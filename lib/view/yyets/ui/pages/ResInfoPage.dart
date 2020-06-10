import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/yyets/app/Api.dart';
import 'package:bill/view/yyets/ui/load/LoadingStatus.dart';
import 'package:bill/view/yyets/utils/constants.dart';
import 'package:bill/view/yyets/utils/mysp.dart';
import 'package:bill/view/yyets/utils/times.dart';
import 'package:bill/view/yyets/utils/toast.dart';
import 'package:bill/view/yyets/utils/tools.dart';
import 'package:fyyets_dl2/RRResManager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ResInfoPage extends StatefulWidget {
  final Map info;

  ResInfoPage(this.info);

  @override
  State createState() => _ResInfoState();
}

class _ResInfoState extends State<ResInfoPage> {
  Map _data;
  LoadingStatus _loadingStatus = LoadingStatus.LOADING;

  void _downloadAndPlay(String rrUri) async {
    if (await Permission.storage.request().isGranted) {
      await RRResManager.addTask(
          info['id'], rrUri, info['poster_b'] ?? info['poster'],
          filmName: info['cnname'],
          episode: info['episode'].toString(),
          season: info['season'].toString());
      Navigator.pushReplacementNamed(context, "/download");
    } else {
      toast("请授予存储权限");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Map get info => widget.info;

  String get channel => info['channel'];

  bool get canDownPlay =>
      _data != null &&
      _data['item_app'] != null &&
      _data['item_app']['name'] != null;

  void _loadData() {
    Future apiCall;
    Future.delayed(Duration(milliseconds: 200), () {
      if (channel == 'tv') {
        apiCall = Api.getResInfo(
            id: info['id'],
            episode: info['episode'],
            season: info['season'].toString());
      } else if (channel == 'movie') {
        apiCall = Api.getResInfo(id: info['id'], itemid: info['itemid']);
      }
      apiCall.then((data) {
        print(data);
        if (mounted) {
          setState(() {
            _loadingStatus = LoadingStatus.NONE;
            _data = data;
            if (canDownPlay) {
              _showTutorial();
            }
          });
        }
      }).catchError((e) {
        if (mounted) {
          setState(() {
            _loadingStatus = LoadingStatus.ERROR;
          });
        }
        _errText = e.message;
        toast(e.message);
      });
    });
  }

  String title() {
    String t = info['cnname'];
    if (info.containsKey('number')) {
      t += '-' + info['number'];
    } else if (info.containsKey('season_cn')) {
      t += info['season_cn'] + "-" + info['episode'];
    }
    return t;
  }

  String _errText = "资源加载失败，请重试";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title()),
        actions: channel == 'tv'
            ? [
                FlatButton(
                  child: Text("查看更多资源"),
                  onPressed: _viewMoreDlLink,
                )
              ]
            : null,
      ),
      body: _loadingStatus == LoadingStatus.NONE
          ? buildBody()
          : getWidgetByLoadingStatus(_loadingStatus, _loadData,
              errText: _errText),
      floatingActionButton: canDownPlay
          ? FloatingActionButton(
              key: _dlKey,
              tooltip: "边下边播",
              backgroundColor: Colors.lightBlue,
              onPressed: () {
                print("RRResManager.checkPlatform():${RRResManager.checkPlatform()}");
                if (RRResManager.checkPlatform()) {
                  _downloadAndPlay(_data['item_app']['name']);
                }
              },
              child: Icon(
                Icons.file_download,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  var _dlKey = GlobalKey();

  _showTutorial() async {
    var sp = await MySp;
    if (!mounted || sp.has(Constants.KEY_TUTORIAL_RES_DL)) {
      return;
    }
    sp.set(Constants.KEY_TUTORIAL_RES_DL, 1);

    TutorialCoachMark(
      context,
      targets: [
        TargetFocus(
          identify: "dl_key_1",
          keyTarget: _dlKey,
          contents: [
            ContentTarget(
              align: AlignContent.left,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "边下边播",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15.0),
                ),
              ),
            )
          ],
        )
      ],
      colorShadow: Colors.blueAccent,
      // DEFAULT Colors.black
      alignSkip: Alignment.bottomLeft,
      textSkip: "我知道了",
    )..show();
  }

  var itemExp = <bool>[];

  _viewMoreDlLink() {
    String url = "http://m1.rrys2019.com/resource/"
        "item?rid=${info['id']}&season=${info['season']}&episode=${info['episode']}";
    launchUri(url);
  }

  Widget buildBody() {
    List resList = _data['item_list'] ?? [];
    if (itemExp.length != resList.length) {
      itemExp = resList.map((i) => i == resList[0]).toList();
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: ExpansionPanelList(
        expansionCallback: (i, isExp) {
          setState(() {
            itemExp[i] = !itemExp[i];
          });
        },
        children: resList.asMap().keys.map((i) {
          var item = resList[i];
          List fs = item['files'];
          return ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: itemExp[i],
              body: GridView.extent(
                shrinkWrap: true,
                children: fs.map((file) {
                  return Card(
                      child: InkWell(
                    onLongPress: () {
                      String addr = file['address'];
                      String pwd = file['passwd'];
                      if (pwd != null && pwd.isNotEmpty) {
                        addr = addr + "\n密码：" + pwd;
                      }
                      setClipboardData(addr);
                      toastLong("资源链接已复制");
                    },
                    onTap: () {
                      String addr = file['address'];
                      print(addr);
                      String pwd = file['passwd'];
                      if (pwd != null && pwd.isNotEmpty) {
                        setClipboardData(pwd);
                        toastLong("网盘密码已复制：$pwd");
                      }
                      launchUri(addr).then((val) {
                        if (!val) {
                          toast("请安装迅雷等下载软件");
                        }
                      }).catchError((e) {
                        print(e);
                        toast(e);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("way: " + file['way'].toString() ?? ""),
                        Text(file['way_name'] ?? ""),
                      ],
                    ),
                  ));
                }).toList(),
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                maxCrossAxisExtent: 90,
              ),
              headerBuilder: (BuildContext context, bool isExpanded) {
                var size = item['size']?.toString();
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (item['format_tip'] ?? "") +
                            "\t\t\t" +
                            (item['foramt'] ?? ""),
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      size == null || size.isEmpty
                          ? Container()
                          : Text(size.toString()),
                      Text(formatSeconds(int.parse(item['dateline'])) ?? "")
                    ],
                  ),
                );
              });
        }).toList(),
      ),
    );
  }
}
