import 'dart:math';

import 'package:bill/view/maomi/player/playui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TileCard extends StatelessWidget {
  final String img;
  final String title;
  final String like;
  final String authorUrl;
  final String mvId;
  final double height;
  final double width;

  List<Color> colors = [Colors.deepOrange,
    Color.fromARGB(255, 113, 175, 164),
    Color.fromARGB(255, 170, 138, 87),
    Color.fromARGB(255, 89, 61, 67),
    Color.fromARGB(255, 178, 190, 126),
    Color.fromARGB(255, 227, 160, 93),];

  TileCard(
      {this.img,
      this.title,
      this.like,
      this.authorUrl,
      this.mvId,
      this.height,
      this.width
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Player(mvId)));
            },
            child:Container(
              color: colors[Random().nextInt(colors.length)],
              child: CachedNetworkImage(
                imageUrl: '$img',
                width: ScreenUtil.screenWidthDp / 2 - 4,
                height: height * ((ScreenUtil.screenWidthDp / 2 - 4) / width),
              ),
            )
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
            child: Text(
              '$title',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            // padding: EdgeInsets.only(
            //     left: ScreenUtil().setWidth(20),
            //     bottom: ScreenUtil().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.favorite,color: Colors.red,size: 15,),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: 5),
                  child: Text(
                    '$like',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(25),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
