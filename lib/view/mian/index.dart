import 'package:flutter/material.dart';
import 'package:bill/view/Pages.dart';
 
class MainPage extends Pages {

  List tabs = ["周", "月", "年"];

  TabController _tabController;

  final TickerProviderStateMixin vsync;

  MainPage(this.vsync);

  @override
  Pages init() {
    _tabController = TabController(length: tabs.length, vsync: vsync);
    return this;
  }

  @override
  PreferredSizeWidget getAppBar() {
    return AppBar( //导航栏
        title: Text("BILL"), 
        actions: <Widget>[ //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight : 4,
          // indicatorSize:TabBarIndicatorSize.label,
          tabs: tabs.map((e) => Tab(text: e)).toList()
        ),
      );
  }

  @override
  Widget getBody() {
    return Main(tabController:_tabController, tabs: tabs,);
  }
}

class Main extends StatefulWidget {


  Main({Key key, @required this.tabController, @required this.tabs }):super(key:key);

  final TabController tabController;
  final List tabs;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        controller: widget.tabController,
        children: widget.tabs.map((e) { //创建3个Tab页
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: 'dahsfknslanflksjlkj'.split("") 
                        //每一个字母都用一个Text显示,字体为原来的两倍
                        .map((c) => Text(c, textScaleFactor: 2.0,)) 
                        .toList(),
                  )
                ),
                
              ),
          );
        }).toList(),
      );
    
    
  }

  Future<Null> _refresh() async {
    print('object');
    return;
  }

}