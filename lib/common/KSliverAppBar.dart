
import 'dart:ui';

import 'package:flutter/material.dart';

class KSliverAppBar extends StatelessWidget{
  final bool pinned;
  final bool floating;
  final double maxHeight;
  final double maxAvatarSize;
  final ImageProvider image;
  final ImageProvider avatar;
  final Widget text;
  KSliverAppBar({
    Key key,
    this.pinned = false,
    this.floating = false,
    this.maxHeight = 200.0,
    this.maxAvatarSize = 120.0,
    @required this.image,
    @required this.avatar,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(    // 可以吸顶的TabBar
        pinned: pinned,
        floating: floating,
        delegate:MySliverAppBar(maxHeight,maxAvatarSize,image,avatar,text)
    );
  }

}

class MySliverAppBar extends SliverPersistentHeaderDelegate{

  final double kToolbarHeight = 56.0;

  final double minLeftLength = 50;

  final double statusBar = MediaQueryData.fromWindow(window).padding.top;

  final double maxHeight;
  final double maxAvatarSize;
  final ImageProvider image;
  final ImageProvider avatar;
  final Widget text;

  MySliverAppBar(
      this.maxHeight,
      this.maxAvatarSize,
      this.image,
      this.avatar,
      this.text
      );

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double width =  MediaQuery.of(context).size.width / 2;
    double height = maxHeight - shrinkOffset < kToolbarHeight ? kToolbarHeight:maxHeight - shrinkOffset;
    double r = (maxHeight - height) / (maxHeight - kToolbarHeight);
    double avatarSize = maxAvatarSize - (maxAvatarSize - 50)  * r;
    double alignX =  - 1 * r;
    double alignY = 0.8 - 0.8 * r;
    double titleLeft = (minLeftLength + 60 ) * r;
    double left = (width - shrinkOffset - avatarSize / 2) > minLeftLength ? width - shrinkOffset - avatarSize / 2 : minLeftLength ;
    return Container(
      //padding: EdgeInsets.fromLTRB(0, statusBar, 0, 0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, statusBar, 0, 0),
                  decoration: BoxDecoration(
                    image:image != null ?DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    ):null,
                  ),
                ),
                ClipRect(
                  child:BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Container(
                        child: Text(" "),
                      )
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, statusBar, 0, 0),
            child: Stack(
              children: [
                Container(
                  height:kToolbarHeight,
                  child:Row(
                    children: [
                      IconButton(
                        onPressed:() => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back, color: Colors.white,),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: left,
                  child: Container(
                    alignment: Alignment(0, -0.3),
                    height: height,
                    width: avatarSize,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image(
                        image: avatar,
                        fit: BoxFit.cover,
                        width: avatarSize,
                      )
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: height,
                  child: Row(
                    children: [
                      Container(width: titleLeft,),
                      Expanded(
                        child: Container(
                          alignment: Alignment(alignX,alignY),
                          child: text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxHeight + statusBar;

  @override
  double get minExtent => kToolbarHeight + statusBar;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}