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
  final String height;
  final String width;
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
              color: Colors.deepOrange,
              child: CachedNetworkImage(
                imageUrl: '$img',
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
