
import 'dart:ui';

import 'package:bill/common/KPlayer.dart';
import 'package:bill/models/comment.dart';
import 'package:bill/models/vedioDetail.dart';
import 'package:bill/utils/StringUtils.dart';
import 'package:bill/view/api/CommentService.dart';
import 'package:bill/view/api/HostListService.dart';
import 'package:bill/view/api/module/Bill.dart';
import 'package:bill/view/comment/index.dart';
import 'package:bill/view/maomi/comment/CommentItem.dart';
import 'package:bill/view/maomi/comment/NewCommentPage.dart';
import 'package:bill/view/maomi/comment/index.dart';
import 'package:bill/view/maomi/userInfo/NewUserInfo.dart';
import 'package:bill/view/maomi/userInfo/UserInfo.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView, NestedScrollViewState;

class NewPlayer extends  StatefulWidget{

  String mvId;
  String uId;
  String url;
  double mvPlayWidth;
  double mvPlayHeight;
  VedioDetail vedioDetail;
  NewPlayer({this.mvId,this.uId,this.url, this.mvPlayWidth, this.mvPlayHeight,this.vedioDetail});

  @override
  State<StatefulWidget> createState() => _NewPlayerState();
}


class _NewPlayerState extends State<NewPlayer> with SingleTickerProviderStateMixin{

  int _page = 1;
  List<Bill> _bills = List();
  List<Comment> _data = [];
// 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();
  final GlobalKey<NestedScrollViewState> _key =
  GlobalKey<NestedScrollViewState>();
  //TabController tabController;
  TabController primaryTC;

  bool isMin = false;
  // double sliverHeight = 600;
  @override
  void initState() {
    primaryTC = TabController(length: 2, vsync: this);
    showRefreshLoading();
    //this.tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _silverBuilder(BuildContext context, bool innerBoxIsScrolled) {
      double width =  MediaQuery.of(context).size.width;
      double minHeight = width * 9 / 16;
      double maxHeight;
      if(widget.mvPlayHeight > widget.mvPlayWidth){
        if(widget.mvPlayHeight < 600){
          maxHeight = widget.mvPlayHeight;
        }else{
          maxHeight = 600;
        }
      }else{
        maxHeight = minHeight;
      }
      return <Widget> [
        SliverPersistentHeader(    // 可以吸顶的TabBar
          pinned: true,
          delegate:KPlayerSliverDelegate(
            videoUrl: widget.url,
            minHeight: minHeight,
            maxHeight: maxHeight,
            mvPlayWidth: widget.mvPlayWidth,
            mvPlayHeight: widget.mvPlayHeight,
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: StickyTabBarDelegate(
            child: Container(
              color: Colors.black87,
              height: 56,
              width: double.infinity,
              child:TabBar(
                labelColor: Colors.white,
                controller: primaryTC,
                tabs: <Widget>[
                  Tab(text: '简介'),
                  Tab(text: '评论'),
                ],
              ),/*ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfo(widget.vedioDetail.mu_id)));
                },
                leading:StringUtils.isEmpty(widget.vedioDetail.mu_avatar)?Image.asset(
                  "assets/imgs/default_avatar.png",
                  width: 40,
                ):Container(
                  height: 40.0,
                  width: 40.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.vedioDetail.mu_avatar,
                    ),
                  ),
                ),
                title: Text(widget.vedioDetail.mu_name,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              )*/
            ),

          ),
        ),
      ];
    }
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
    //statusBar height
    statusBarHeight +
        //pinned SliverAppBar height in header
        kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.black38,
      body:Container(
        padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        child: NestedScrollView(
          key: _key,
          headerSliverBuilder: _silverBuilder,
          //1.[pinned sliver header issue](https://github.com/flutter/flutter/issues/22393)
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
          //2.[inner scrollables in tabview sync issue](https://github.com/flutter/flutter/issues/21868)
          innerScrollPositionKeyBuilder: () {
            String index = 'Tab';

            index += primaryTC.index.toString();

            return Key(index);
          },
          body:Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black45
            ),
            child:TabBarView(
                controller: primaryTC,
                children: <Widget>[
                  NewUserInfo(widget.uId, Key('Tab0')),
                  NewCommentPage(widget.mvId,Key('Tab1')),
                ]
            ) /*RefreshIndicator(
              key: _refreshKey,
              onRefresh: _onRefresh,
              child: ListView.separated(

                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                itemBuilder: (buildContext, index) {
                  return items(context, index);
                },
                itemCount: _data.isEmpty ? 0 : _data.length+1,
                separatorBuilder: (buildContext, index) {
                  return Divider(
                    height: 0.5,
                    color: Colors.grey,
                  );
                },
              ),*/
            ),
          ),
      ),
    );
  }

  // 加载数据
  void _loadData(int page) {
    HostListService().getComments(widget.mvId, _page).then((value) => {
      setState(() {
        _data.addAll(value) ;
      })
    });
  }

  // 下拉刷新
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(milliseconds: 200), () {
      print("正在刷新...");
      _page = 1;
      this._data.clear();
      _loadData(_page);
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(milliseconds: 200), () {
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

  // item控件
  Widget items(context, index) {
    if (index == _data.length) {
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
    return CommentItem(_data[index]);
  }
}
class KPlayerSliverDelegate extends SliverPersistentHeaderDelegate {

  final double minHeight;
  final double maxHeight;
  final String videoUrl;
  double mvPlayWidth;
  double mvPlayHeight;


  KPlayerSliverDelegate({this.minHeight, this.maxHeight, this.videoUrl,
    this.mvPlayWidth, this.mvPlayHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black
      ),
      child: Center(
        child: KPlayer(videoUrl,mvPlayWidth,mvPlayHeight),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight; // 展开状态下组件的高度；

  @override
  double get minExtent => minHeight; // 收起状态下组件的高度；

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => 56; // 展开状态下组件的高度；

  @override
  double get minExtent => 56; // 收起状态下组件的高度；

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
