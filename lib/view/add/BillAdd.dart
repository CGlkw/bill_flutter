
import 'package:bill/common/BillIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BillAdd extends StatefulWidget{
  @override
  _BillAddState createState() => _BillAddState();
}

class _BillAddState extends State<BillAdd>{

  List icon = [
    {'icon':'canyin','name':'餐饮'},
    {'icon':'zaocan','name':'早餐'},
    {'icon':'yule','name':'娱乐'},
    {'icon':'feiji','name':'飞机'},
    {'icon':'huoche','name':'火车'},
    {'icon':'qian','name':'理财'},
    {'icon':'haitan','name':'旅游'},
  ];

  int selectIndex = -1;

  bool isShow = false;

  List<Widget> iconButtons = [];

  BuildContext _context;

  @override
  void initState() {
    _iconInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Add')
      ),
      body:Container(
        alignment: Alignment.center,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, //横轴三个子widget
              childAspectRatio: 1.0 //宽高比为1时，子widget
          ),
          children:iconButtons
        )
      )
    );
    
  }

  Widget _buildBottomSheet() => BottomSheet(
    onClosing: () => {selectIndex = -1}, 
    builder: (_) => (Container(
        height: 300.0,
        child: selectIndex != -1? Icon(BillIcons.all[icon[selectIndex]['icon']],size: 40,) : null,
    ))
  );

  _iconInit(){
    int i = 0;
    icon.forEach((element) {
      iconButtons.add(
        InkWell(
          onTap: () {
            selectIndex = i;
            isShow = !isShow;
            isShow ?Scaffold.of(_context).showBottomSheet((context) => _buildBottomSheet()) : Navigator.of(_context).pop();
          },
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(BillIcons.all[element['icon']],size: 40,),
              Text(element['name'])
            ]
          ),
        )
      );
      i++;
    });
  }
}