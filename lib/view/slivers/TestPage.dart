import 'dart:async';
import 'package:bill/common/BillPlayer.dart';
import 'package:flutter/material.dart'
    hide NestedScrollView, NestedScrollViewState;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class LoadMoreDemo extends StatefulWidget {
  @override
  _LoadMoreDemoState createState() => _LoadMoreDemoState();
}

class _LoadMoreDemoState extends State<LoadMoreDemo>
    with TickerProviderStateMixin {
  TabController primaryTC;
  final GlobalKey<NestedScrollViewState> _key =
  GlobalKey<NestedScrollViewState>();
  @override
  void initState() {
    primaryTC = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    primaryTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
    //statusBar height
    statusBarHeight +
        //pinned SliverAppBar height in header
        kToolbarHeight;
    return NestedScrollView(
      key: _key,
      headerSliverBuilder: (BuildContext c, bool f) {
        return <Widget>[
          SliverPersistentHeader(    // 可以吸顶的TabBar
            pinned: true,
            delegate:KPlayerSliverDelegate(maxHeight: 600,minHeight: 300),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyTabBarDelegate(
              child: TabBar(
                labelColor: Colors.black,
                controller: primaryTC,
                tabs: <Widget>[
                  Tab(text: 'Home'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
          ),
        ];
      },
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
      body: TabBarView(
        controller: primaryTC,
        children: const <Widget>[
          TabViewItem(Key('Tab0')),
          TabViewItem(Key('Tab1')),
        ],
      ),
    );
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
class KPlayerSliverDelegate extends SliverPersistentHeaderDelegate {

  final double minHeight;
  final double maxHeight;
  final String videoUrl;

  KPlayerSliverDelegate({this.minHeight, this.maxHeight, this.videoUrl});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black
      ),
      child: Center(
        child: BillPlayer('https://gss3.baidu.com/6LZ0ej3k1Qd3ote6lo7D0j9wehsv/tieba-smallvideo/60_005dc4f51afef28e246a3818cf147595.mp4','9','16'),
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

class TabViewItem extends StatefulWidget {
  const TabViewItem(this.tabKey);
  final Key tabKey;
  @override
  _TabViewItemState createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem>
    with AutomaticKeepAliveClientMixin {

  List<int> data = [];
  int _page= 1;
  EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollViewInnerScrollPositionKeyWidget(widget.tabKey,
      EasyRefresh(
        //firstRefresh: true,
        controller: _controller,
        header: MaterialHeader(),
        footer: MaterialFooter(),
      child: ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Text(widget.tabKey.toString() + ': ListView$index'),
          );
        },
        itemCount: data.length,
      ),
      onRefresh: () => _onRefresh(),
      onLoad: () => _loadMoreData(),
    ),
    );
  }

// 下拉刷新
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(milliseconds: 300), () async {
      print("正在刷新...");
      setState(() {
        data.clear();
        _page = 1;
        _loadData(_page);
      });
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(milliseconds: 300), () {
      print("正在加载更多...");
      setState(() {
        _page ++;
        _loadData(_page);
      });
    });
  }

  _loadData (page){
    for (int i = 0; i < 10; i++) {
      data.add(0);
    }
  }
  @override
  bool get wantKeepAlive => true;
}