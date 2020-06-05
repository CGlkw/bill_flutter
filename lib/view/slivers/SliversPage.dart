import 'dart:math';
import 'dart:ui';

import 'package:bill/common/SlideButton.dart';
import 'package:bill/models/comment.dart';
import 'package:bill/view/api/BillService.dart';
import 'package:bill/view/api/CommentService.dart';
import 'package:bill/view/api/module/Bill.dart';
import 'package:bill/view/comment/CommentItem.dart';
import 'package:bill/view/comment/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliversPage extends  StatefulWidget{

  @override
  State<StatefulWidget> createState() => _SliversState();
}


class _SliversState extends State<SliversPage> with SingleTickerProviderStateMixin{

  int _page = 1;
  List<Bill> _bills = List();
  List<Comment> _data = [];
// 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();

  TabController tabController;

  @override
  void initState() {
    CommentService().getCommentList().then((value) => {
        setState(() {
      print("加载数据。。。");
      _data.addAll(value) ;
    })
    });
    this.tabController = TabController(length: 2, vsync: this);
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
      body:CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(    // 可以吸顶的TabBar
              pinned: true,
              delegate:KPlayerSliverDelegate(),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyTabBarDelegate(
              child: TabBar(
                labelColor: Colors.black,
                controller: this.tabController,
                tabs: <Widget>[
                  Tab(text: 'Home'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: this.tabController,
              children: <Widget>[
                Center(child: Text('Content of Home')),
                Container(
                  color: Colors.white,
                  child: RefreshIndicator(
                    key: _refreshKey,
                    onRefresh: _onRefresh,
                    child:ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      itemCount: _data.length,
                      itemBuilder: (context, i) => CommentItem(_data[i]),
                    ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 加载数据
  void _loadData(int page) {
    CommentService().getCommentList().then((value) => {
        setState(() {
          print("加载数据。。。");
        _data.addAll(value) ;
      })
    });
  }

  // 下拉刷新
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(milliseconds: 300), () {
      print("正在刷新...");
      _page = 1;
      this._data.clear();
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
class KPlayerSliverDelegate extends SliverPersistentHeaderDelegate {


  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    print(shrinkOffset);
    return Container(
      decoration: BoxDecoration(
        color: Colors.black
      ),
      child: Center(
        child: Text("video",
          style: TextStyle(
            fontSize: 50,
            color: Colors.white
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 600; // 展开状态下组件的高度；

  @override
  double get minExtent => 300; // 收起状态下组件的高度；

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
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