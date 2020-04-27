import 'package:flutter/material.dart';
import 'package:bill/view/Pages.dart';

import 'charts/BillPieChart.dart';
 
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

class _MainState extends State<Main> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin{

  TabController _tabController;
  List tabs;
  int index = 0;

  List tabs2 = [['本周','上周','12周'],
                ['本月','上月','二月'],
                ['2020年','2019年','2018年'],];

  @protected
  bool get wantKeepAlive=>true;

  @override
  void initState() {
    tabs = tabs2[index];
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.tabController.addListener((){
      setState(() {
        tabs = tabs2[widget.tabController.index];
        _tabController = TabController(length: tabs.length, vsync: this);
      });
    });


    return TabBarView(
        controller: widget.tabController,
        children: widget.tabs.map((e) { //创建3个Tab页
          return Column(
            children:[
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                indicatorSize:TabBarIndicatorSize.label,
                tabs: tabs.map((e) => Tab(
                  text: e,
                )).toList()
              ),
              Row(
                children: [
                  Text('$e消费统计'),
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        child: Text('本周'),
                        value: '本周',
                      ),
                      DropdownMenuItem(
                        child: Text('上周'),
                        value: '上周',
                      ),DropdownMenuItem(
                        child: Text('12周'),
                        value: '12周',
                      )
                    ],
                    value: '本周',
                    onChanged: _onChanged,
      //              isDense: false,// 这个当按钮嵌入添加的容器中时，非常有用
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                controller: _tabController,
                children: 
                  tabs.map((e) {
                    return Container(
                      alignment: Alignment.topCenter,
                      width: double.infinity,
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(16.0),              
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 300.0,
                                child:   DonutAutoLabelChart.withSampleData()
                              ),
                            ]
                          ),
                        ),
                      ),
                    );

                  }).toList(),
                
                ),
              ),
              
            ]
          );
            
        }).toList(),
      );  
  }

  Future<Null> _refresh() async {
    print('object');
    return;
  }

  Future<Null> _onChanged(value) async {
    print(value);
    return;
  }

}