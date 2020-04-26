import 'package:flutter/material.dart';
import 'package:bill/view/Pages.dart';
import 'package:bill/view/list/BillList.dart';
import 'package:bill/view/mian/index.dart';

import 'info_draver/index.dart';


class Index extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<Index> with TickerProviderStateMixin{

  List<Pages> pages = new List();

  int _currentIndex = 0;

  @override
  void initState() {
    pages
      ..add(MainPage(this).init())
      ..add(BillListPage(this).init());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pages[_currentIndex].getAppBar(),
      body:pages[_currentIndex].getBody(),
      drawer: MyDrawer(), //抽屉
      bottomNavigationBar: BottomAppBar( // 底部导航
        color: Colors.white,
        shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          children: [
            buildBotomItem(_currentIndex, 0, Icons.home, "主页"),
            buildBotomItem(_currentIndex, 1, Icons.list, "账单"),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton( //悬浮按钮
          child: Icon(Icons.add),
          onPressed:(){
            Navigator.of(context).pushNamed('bill_add');
          },
          
      ),
      
    );
  }

  Future<Null> _refresh() async {
    print('object');
    return;
  }
 
  /// @param selectIndex 当前选中的页面
  /// @param index 每个条目对应的角标
  /// @param iconData 每个条目对就的图标
  /// @param title 每个条目对应的标题
  buildBotomItem(int selectIndex, int index, IconData iconData, String title) {
    //未选中状态的样式
    TextStyle textStyle = TextStyle(fontSize: 12.0,color: Colors.grey);
    MaterialColor iconColor = Colors.grey;
    double iconSize=20;
    EdgeInsetsGeometry padding =  EdgeInsets.only(top: 8.0);

    if(selectIndex==index){
      //选中状态的文字样式
      textStyle = TextStyle(fontSize: 13.0,color: Theme.of(context).primaryColor);
      //选中状态的按钮样式
      iconColor = Theme.of(context).primaryColor;
      iconSize=25;
      padding =  EdgeInsets.only(top: 6.0);
    }
    Widget padItem = SizedBox();
    if (iconData != null) {
      padItem = Padding(
        padding: padding,
        child: AnimatedContainer(
          duration: Duration(seconds: 5),
          color: Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(
                  iconData,
                  color: iconColor,
                  size: iconSize,
                ),
                Text(
                  title,
                  style: textStyle,
                )
              ],
            ),
          ),
        ),
      );
    }
    Widget item = Expanded(
      flex: 1,
      child: new GestureDetector(
        onTap: () {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: SizedBox(
          height: 52,
          child: padItem,
        ),
      ),
    );
    return item;
  }
}