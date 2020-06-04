import 'dart:math';
import 'dart:ui';

import 'package:bill/common/SlideButton.dart';
import 'package:bill/view/api/BillService.dart';
import 'package:bill/view/api/module/Bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliversPage extends  StatefulWidget{

  @override
  State<StatefulWidget> createState() => _SliversState();
}


class _SliversState extends State<SliversPage> {

  int _page = 1;
  List<Bill> _bills = List();
// 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    showRefreshLoading();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            /*SliverAppBar(
              pinned: true,
              elevation: 0,
              expandedHeight: 250,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child:BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/imgs/default_avatar.png",
                          width: 120,
                        ),
                      ),
                    ),
                  ),
                  FlexibleSpaceBar(
                    title: Text("UserInfo"),
                      centerTitle:true,
                  ),
                ],
              )
            ),*/
            SliverPersistentHeader(    // 可以吸顶的TabBar
              pinned: true,
              delegate:MySliverAppBar()
            ),
            SliverFixedExtentList(        // SliverList的语法糖，用于每个item固定高度的List
              delegate: SliverChildBuilderDelegate(
                    (context, index) => items(context, index),
                childCount: _bills.length,
              ),
              itemExtent: 80,
            ),
          ],
        ),
      ),
    );
  }
// item控件
  Widget items(context, index) {
    if (index == _bills.length) {
      return Container(
        child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RefreshProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    strokeWidth: 2.0,
                  ),
                ],
              ),
            )
        ),
      );
    }
    var key = GlobalKey<SlideButtonState>();
    return Container(
          color:Colors.white,
          child: ListTile(
            title: Text('${_bills[index].type}'),
            subtitle: Text('${_bills[index].remark}'),
            trailing: Text('${_bills[index].money}'),
          ),
        );



  }
  Widget buildAction(GlobalKey<SlideButtonState> key, String text, Color color,
      GestureTapCallback tap) {

    return Padding(
        padding: EdgeInsets.only(top: 1, bottom: 1),
        child: InkWell(
          onTap: tap,
          child: Container(
            alignment: Alignment.center,
            width: 80,
            color: color,
            child: Text(text,
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        )
    );
  }
  // 加载数据
  void _loadData(int page) {
    BillService().getBillList(page:page).then((value) => {
      setState(() {
        this._bills.addAll(value);
      })
    });
  }

  // 下拉刷新
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(milliseconds: 300), () {
      print("正在刷新...");
      _page = 1;
      this._bills.clear();
      _loadData(_page);
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(milliseconds: 2000), () {
      print("正在加载更多...");
      _page++;
      _loadData(_page);
    });
  }

  // 刷新
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {
      });
      return true;
    });
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => this.child.preferredSize.height; // 展开状态下组件的高度；

  @override
  double get minExtent => this.child.preferredSize.height; // 收起状态下组件的高度；

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate{

  final double kToolbarHeight = 56.0;

  final double maxHeight = 200.0;

  final double maxAvatarSize = 120;

  final double minLeftLength = 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double width =  MediaQuery.of(context).size.width / 2;
    double height = maxHeight - shrinkOffset < kToolbarHeight ? kToolbarHeight:maxHeight - shrinkOffset;
    double r = (maxHeight - height) / (maxHeight - kToolbarHeight);
    double avatarSize = maxAvatarSize - (maxAvatarSize - 50)  * r;
    double alignX =  - 1 * r;
    double alignY = 0.8 - 0.8 * r;
    double titleLeft = (minLeftLength + 66 ) * r;
    double left = (width - shrinkOffset - avatarSize / 2) > minLeftLength ? width - shrinkOffset - avatarSize / 2 : minLeftLength ;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
                fit: BoxFit.cover,
              ),
              ClipRect(
                child:BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Container()
                ),
              ),
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
              child: Image.asset(
                "assets/imgs/default_avatar.png",
                width: avatarSize,
              ),
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
                  child: Text("userInfo",style: TextStyle(fontSize: 30,color: Colors.white70),),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

class StickyDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  StickyDelegate({
    @required this.child,
    @required this.minHeight,
    @required this.maxHeight
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child,);
  }

  @override
  double get maxExtent => max(maxHeight, minHeight); // 展开状态下组件的高度；

  @override
  double get minExtent => minHeight; // 收起状态下组件的高度；

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}