
import 'package:bill/common/BillIcon.dart';
import 'package:bill/view/add/component/Test.dart';
import 'package:bill/view/api/BillService.dart';
import 'package:bill/view/api/module/Bill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'component/AddKeyBord.dart';

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

  _onSubmit(Bill bill){
    BillService().addBill(bill);

  }

  _iconInit(){
    int i = 0;
    icon.forEach((element) {
      iconButtons.add(
        InkWell(
          onTap: () {
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestHero(element)));
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return  AddKeyBord(
                  name:element,
                  controller: TextEditingController(),
                  onSubmit: _onSubmit,
                );
              },
            ).then((val) {
            });
          },
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(tag:element['icon'],child: Icon(BillIcons.all[element['icon']],size: 40,)),
              Text(element['name'])
            ]
          ),

        )
      );
      i++;
    });
  }
}