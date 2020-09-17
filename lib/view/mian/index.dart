import 'package:bill/api/BillService.dart';
import 'package:bill/api/module/Bill.dart';
import 'package:bill/utils/DateUtils.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/Pages.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'charts/BillPieChart.dart';
import 'charts/BillStackedBarChart.dart';
 
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


  List<BillChartDate> tabs;
  List<TabController> _tabControllers;
  int _firstIndex = 0;
  int _secondIndex = 0;

  List<List<BillChartDate>> tabs2 = [[BillChartDate('本周',null,null)],
  [BillChartDate('本月',null,null)],
  [BillChartDate('今年',null,null)]];

  List<Map<int,Widget>> pieCharts = [{},{},{}];
  List<Map<int,Widget>> stackCharts = [{},{},{}];


  @protected
  bool get wantKeepAlive=>false;

  // 刷新
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {

      return true;
    });
  }

  @override
  void initState() {

    
    showRefreshLoading();
     BillService().getMinMaxTime().then((value) => { 
      setState(() {    
        tabs2[0]= BillService().getWeekChartDate(value['minTime'],value['maxTime']);
        tabs2[1]= BillService().getMonthChartDate(value['minTime'],value['maxTime']);
        tabs2[2]= BillService().getYearChartDate(value['minTime'],value['maxTime']);
        _tabControllers = new List()
          ..add(TabController(length: tabs2[0].length, vsync: this))
          ..add(TabController(length: tabs2[1].length, vsync: this))
          ..add(TabController(length: tabs2[2].length, vsync: this));

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
        _firstIndex = widget.tabController.index;
        _secondIndex = _tabControllers[_firstIndex].index;
        
      });
      _createSampleData();
    });
    
    return TabBarView(
        controller: widget.tabController,
        children: widget.tabs.asMap().keys.map((e1) { //创建3个Tab页
          if(_tabControllers == null ){
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          }
          _tabControllers[e1].addListener(() {
            setState(() {
            _secondIndex = _tabControllers[e1].index;
            });
            _createSampleData();
          });
          return Column(
            children:[
              TabBar(
                controller: _tabControllers[e1],
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                indicatorSize:TabBarIndicatorSize.label,
                tabs: tabs2[e1].map((e) => Tab(
                  text: e.name,
                )).toList()
              ),
              
              Expanded(
                child: TabBarView(
                controller: _tabControllers[e1],
                children: 
                  tabs2[e1].asMap().keys.map((e2) {
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
                                child: pieCharts[e1][e2] ?? Center(
                                  child: Container(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              ),
                              Container(
                                width: double.infinity,
                                height: 300.0,
                                child: stackCharts[e1][e2] ?? Center(
                                  child: Container(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
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
    if(pieCharts.length > 0 
        && pieCharts[_firstIndex] !=null 
        && pieCharts[_firstIndex].length > 0
        && pieCharts[_firstIndex][_secondIndex] != null){
          return;
    }
    _reFreshChartDate();
  }

  _reFreshChartDate(){
    BillChartDate billChartDate = tabs2[_firstIndex][_secondIndex];

    BillService().getBillByDate(billChartDate.startTime, billChartDate.endTime).then((value) => {
      _createPieChartData(value),
      _createStackChartData(value)
    });
  }
  _createStackChartData(value){
      Map<String, List<PieBillDate>> map = new Map();
      int i = 0;
      if(_firstIndex == 0){
        value.forEach((element) {
          if(map.containsKey(element.type)){
            map[element.type].add(PieBillDate(DateUtils.getWeekName(element.time), element.money, null));
          }else{
            map[element.type] = List()..add(PieBillDate(DateUtils.getWeekName(element.time), element.money, null));
          }
        });
      }else if(_firstIndex == 1){
        value.forEach((element) {
          if(map.containsKey(element.type)){
            map[element.type].add(PieBillDate('${element.time.day}', element.money, null));
          }else{
            map[element.type] = List()..add(PieBillDate('${element.time.day}', element.money, null));
          }
        });
      }else{
        value.forEach((element) {
          if(map.containsKey(element.type)){
            map[element.type].add(PieBillDate('${element.time.day}', element.money, null));
          }else{
            map[element.type] = List()..add(PieBillDate('${element.time.day}', element.money, null));
          }
        });
      }
      
      var  _seriesList = List<charts.Series<PieBillDate, String>>();
      map.forEach((key, value) {
        _seriesList.add(
          new charts.Series<PieBillDate, String>(
            id: key,
            domainFn: (PieBillDate sales, _) => sales.type,
            measureFn: (PieBillDate sales, _) => sales.money,
            data: value,
          ),);
      });
    setState(() {
      var stackChart = StackedBarChart(_seriesList,animate:true);
      stackCharts[_firstIndex][_secondIndex] = stackChart;
    });
  }
  _createPieChartData(value){
    Map<String, double> map = new Map();
    List<PieBillDate> data = [];
    Color c=  Theme.of(context).primaryColor;
    int i = 0;
    value.forEach((element) {
      if(map.containsKey(element.type)){
        map[element.type] += element.money;
      }else{
        map[element.type] = element.money;
      }
    });
    
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
    });
    setState(() {
      var  _seriesList =  [new charts.Series<PieBillDate, String>(
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
      var pieChart = DonutAutoLabelChart(_seriesList,animate:true);
      pieCharts[_firstIndex][_secondIndex] = pieChart;
    });
  }

  Future<Null> _refresh() async {
    _reFreshChartDate();
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