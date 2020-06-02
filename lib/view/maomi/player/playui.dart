import 'dart:ui';

import 'package:bill/common/BillPlayer.dart';
import 'package:bill/models/index.dart';
import 'package:bill/models/vedioDetail.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget{

  final String mvId;

  Player(this.mvId);

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player> with TickerProviderStateMixin{
    VedioDetail detail;
    TabController tabController;
    @override
    void initState() {
      super.initState();
      tabController=TabController(length: 2, vsync: this);
      HostListService().getDetail(widget.mvId).then((value) => {           
        setState(() {
          detail = value;
        }),
      }); 
      // detail = new VedioDetail();
      
      // setState(() {
      //   detail.mv_img_url = "https://pic1.zhimg.com/v2-664e58f90e12b9263d6c29a7cd8eb202_1200x500.jpg";
      // detail.mv_play_url = "https://player.youku.com/embed/XNDY3MjAzNTk3Ng==?client_id=f7d81b29f4146ce2";
      // });    
    }
  @protected
  bool get wantKeepAlive=>false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
      Stack(
        fit: StackFit.expand,
        children: []..addAll(
          detail == null ? 
            [Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )] :
          <Widget>[
            CachedNetworkImage(
              imageUrl:detail.mv_img_url,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child:BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child:Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: AppBar(
                            title: Text('MaoMi'),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          )
                        ),
                        TabBar(
                              controller:tabController,
                              tabs: [
                                Tab(text:"视频"),
                                Tab(text:"评论"),
                              ],
                            ),
                        Expanded(
                          child: TabBarView(
                            controller:tabController,
                            children: [
                              Center(
                                child:BillPlayer(detail.mv_play_url,detail.mv_play_width,detail.mv_play_height),
                              ),
                              
                              CommentPage(),
                            ]
                          ),
                        )
                      ]
                    ), 
                )
            ),
          ]
        )
      )        
    );
  }
}


class VedioPage extends StatefulWidget {

  String url;
  String mv_play_width;
  String mv_play_height;

  VedioPage(this.url, this.mv_play_height, this.mv_play_width);

  @override
  State<StatefulWidget> createState() {
    return _VedioPageState();
  }
}

class _VedioPageState extends State<VedioPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    print("VedioPage init");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  BillPlayer(widget.url,widget.mv_play_width,widget.mv_play_height);
           
  }

  @override
  bool get wantKeepAlive => true;
}

class CommentPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _CommentPageState();
  }
}

class _CommentPageState extends State<CommentPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    print("VedioPage init");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
            child: Text("评论"),
          );
  }

  @override
  bool get wantKeepAlive => true;
}