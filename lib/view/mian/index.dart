import 'package:bill/view/api/BillService.dart';
import 'package:bill/view/api/module/Bill.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/Pages.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  List<BillChartDate> tabs;
  int index = 0;
  List<charts.Series> _seriesList;

  List<List<BillChartDate>> tabs2 = [[BillChartDate('本周',null,null)],
  [BillChartDate('本月',null,null)],
  [BillChartDate('今年',null,null)]];

  Widget pieChart;

  @protected
  bool get wantKeepAlive=>true;

  @override
  void initState() {

    tabs = tabs2[index];
     _tabController = TabController(length: tabs.length, vsync: this);
     BillService().getMinMaxTime().then((value) => { 
      setState(() {    
        tabs2[0]= BillService().getWeekChartDate(value['minTime'],value['maxTime']);
        tabs2[1]= BillService().getMonthChartDate(value['minTime'],value['maxTime']);
        tabs2[2]= BillService().getYearChartDate(value['minTime'],value['maxTime']);
        tabs = tabs2[index];
        _tabController = TabController(length: tabs.length, vsync: this);
        _createSampleData();
        
      })
    });

    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.tabController.addListener((){
      setState(() {
        tabs = tabs2[widget.tabController.index];
        _tabController = TabController(length: tabs.length, vsync: this);
        _createSampleData();
      });
    });
    _tabController.addListener(() {
      _createSampleData();
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
                  text: e.name,
                )).toList()
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
                                child: pieChart
                              )
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

  void _createSampleData() {
    BillChartDate billChartDate = tabs[_tabController.index];
    Map<String, double> map = new Map();
    List<PieBillDate> data = [];
    Color c=  Theme.of(context).primaryColor;
    int i = 0;
    BillService().getBillByDate(billChartDate.startTime, billChartDate.endTime).then((value) => {
      value.forEach((element) {
        if(map.containsKey(element.type)){
          map[element.type] += element.money;
        }else{
          map[element.type] = element.money;
        }
      }),
      
      map.forEach((key, value) {
        data.add(PieBillDate(key, value, 
          charts.Color(
              r:c.red,
              g:c.green,
              b:c.blue,
              a:int.parse(((map.length - i) /map.length * 255).toStringAsFixed(0))
            )
        ));
        i++;
      }),
       setState(() {
         _seriesList =  [new charts.Series<PieBillDate, String>(
            id: 'Sales',
            domainFn: (PieBillDate sales, _) => sales.type,
            measureFn: (PieBillDate sales, _) =>sales.money ,
            seriesColor: charts.Color(
              r:Colors.red.red,
              g:Colors.red.green,
              b:Colors.red.blue
            ),
             colorFn: (PieBillDate sales, _) => sales.color,
            data: data,
            // Set a label accessor to control the text of the arc label.
            labelAccessorFn: (PieBillDate row, _) => '${row.money.toStringAsFixed(2)}',
          )];
          pieChart = DonutAutoLabelChart(_seriesList,animate:true);
       })
    });


     
    
  }

  Future<Null> _refresh() async {
    _createSampleData();
    return;
  }

  Future<Null> _onChanged(value) async {
    print(value);
    return;
  }

}

class PieBillDate {
  final String type;
  final double money;
  final charts.Color color;

  PieBillDate(this.type, this.money, this.color);
}