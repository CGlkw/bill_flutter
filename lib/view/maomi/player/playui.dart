import 'dart:ui';

import 'package:bill/common/BillPlayer.dart';
import 'package:bill/models/vedioDetail.dart';
import 'package:bill/utils/StringUtils.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:bill/view/maomi/comment/index.dart';
import 'package:bill/view/maomi/userInfo/UserInfo.dart';
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
                            actions:[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfo(detail.mu_id)));
                                },
                                child:StringUtils.isEmpty(detail.mu_avatar)?Image.asset(
                                  "assets/imgs/default_avatar.png",
                                  width: 40,
                                ):Container(
                                  height: 40.0,
                                  width: 40.0,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      detail.mu_avatar,
                                    ),
                                  ),
                                ),
                              )
                            ],
                            title: TabBar(
                              controller:tabController,
                              tabs: [
                                Tab(text:"视频"),
                                Tab(text:"评论"),
                              ],
                            ),

                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          )
                        ),

                        Expanded(
                          child: TabBarView(
                            controller:tabController,
                            children: [
                              Center(
                                child:BillPlayer(detail.mv_play_url,detail.mv_play_width,detail.mv_play_height),
                              ),
                              CommentPage(widget.mvId),
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
