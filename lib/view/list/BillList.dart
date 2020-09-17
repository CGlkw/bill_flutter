import 'package:bill/api/BillService.dart';
import 'package:bill/api/module/Bill.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/Pages.dart';
import 'package:bill/common/SlideButton.dart';

class BillListPage extends Pages{

  List tabs = ['支出','收入'];

  TabController _tabController;

  final TickerProviderStateMixin vsync;

  BillListPage(this.vsync);

  @override
  Pages init() {
    _tabController = TabController(length: tabs.length, vsync: vsync);
    return this;
  }

  @override
  PreferredSizeWidget getAppBar() {
    return AppBar( //导航栏
        title: TabBar(
          controller: _tabController,
          indicatorWeight : 4,
          isScrollable: true,
          indicatorSize:TabBarIndicatorSize.label,
          tabs: tabs.map((e) => Tab(text: e)).toList()
        ), 
      );
  }

  @override
  Widget getBody() {
    return BillList(tabs: tabs, tabController: _tabController,);
  }

}

class BillList extends StatefulWidget {

  BillList({Key key, @required this.tabController, @required this.tabs}):super(key:key);

  final TabController tabController;
  final List tabs;

  @override
  _BillListState createState() => _BillListState();
}

class _BillListState extends State<BillList>{
  int _page = 1;
  List<Bill> _bills = List();
// 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();

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
      _bills.clear();
        _loadData(_page);
      
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(milliseconds: 300), () {
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
    
    return TabBarView(
        controller: widget.tabController,
        children: widget.tabs.map((e) { //创建Tab页
          return Container(
            alignment: Alignment.center,
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: _onRefresh,
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.all(8.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (buildContext, index) {
                  return items(context, index);
                },
                itemCount: _bills.isEmpty ? 0 : _bills.length+1,
                separatorBuilder: (buildContext, index) {
                  return Divider(
                    height: 0.5,
                    color: Colors.grey,
                  );
                },
              ),      
            ),
          );
        }).toList(),
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
    return 
    SlideButton(
      key: key,
      child: Container(
        color:Colors.white,
        child: ListTile(
          title: Text('${_bills[index].type}'),
          subtitle: Text('${_bills[index].remark}'),
          trailing: Text('${_bills[index].money}'),
          
        ),
      ),
      
      singleButtonWidth: 80,
      buttons: [
          buildAction(key, "编辑", Colors.amber, () {
            key.currentState.close();
          }),
          buildAction(key, "删除", Colors.red, () {
            key.currentState.close();
          }),
      ],
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
}