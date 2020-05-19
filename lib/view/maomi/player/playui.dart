import 'dart:ui';

import 'package:bill/common/BillPlayer.dart';
import 'package:bill/models/index.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget{

  final String mvId;

  Player(this.mvId);

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player>{
    VedioDetail detail;
    @override
    void initState() {
      super.initState();
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
                child: Center(
                  child: BillPlayer(detail.mv_play_url,detail.mv_play_width,detail.mv_play_height),
                ),
              ),
            ),
          ]
        //   ..add(Positioned(
        //     top: 0,
        //     left: 0,
        //     child:  Container(
        //       height: 100,
        //       width: double.infinity,
        //       child: AppBar(
        //         title: Text('MaoMi'),
        //         elevation: 0,
        //         backgroundColor: Colors.transparent,
        //       )
        //     ),
        //   )
         
        // )
        )
      )        
    );
  }
}