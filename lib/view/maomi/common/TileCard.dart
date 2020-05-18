import 'package:bill/view/maomi/player/playui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TileCard extends StatelessWidget {
  final String img;
  final String title;
  final String author;
  final String authorUrl;
  final String mvId;
  TileCard(
      {this.img,
      this.title,
      this.author,
      this.authorUrl,
      this.mvId
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
              color: Colors.deepOrange,
              child: CachedNetworkImage(
                imageUrl: '$img'
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
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // CircleAvatar(
                //   backgroundImage: NetworkImage('$authorUrl'),
                //   radius: ScreenUtil().setWidth(30),
                //   // maxRadius: 40.0,
                // ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  width: ScreenUtil().setWidth(250),
                  child: Text(
                    '$author',
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
