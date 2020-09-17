
import 'package:bill/common/BillIcon.dart';
import 'package:flutter/material.dart';
import 'package:bill/api/module/BillType.dart';
import 'package:bill/api/BillTypeService.dart';

class BillTypeEdit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _BillTypeEditState();

}

class _BillTypeEditState extends State<BillTypeEdit>{

  List<BillType> billTypes = List();

  @override
  void initState() {
    BillTypeService().queryAll().then((value) => {
      setState((){
        billTypes = value;
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Bill Type Edit'),
          actions: [
            InkWell(
              onTap: (){
                _onSave();
              },
              child: Container(
                padding: EdgeInsets.only(left: 18,right: 18),
                child: Center(
                  child: Text("保存",style: TextStyle(
                      color: Colors.white
                  ),),
                ),
              ),
            )
          ],
        ),
        body:Container(
            alignment: Alignment.center,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, //横轴三个子widget
                  childAspectRatio: 1.0 //宽高比为1时，子widget
              ),
              itemBuilder: (context, index) =>_buildItem(index),
              itemCount: billTypes.length,
            )
        )
    );
  }

  Widget _buildItem(index){
    return Stack(
      children: [
        _buildIcon(billTypes[index]),
        Positioned(
          right: 0.0,
          child:Container(
              child: Checkbox(
                value: billTypes[index].isSelect,
                onChanged: (b){
                  setState(() {
                    billTypes[index].isSelect = ! billTypes[index].isSelect;
                  });
                },
              ),
            ),

        )
      ],
    );
  }

  Widget _buildIcon(element){
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {
            element.isSelect = ! element.isSelect;
          });
        },

        child:Container(
          width: 70,
          height: 70,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(BillIcons.all[element.icon],size: 40),
                Text(element.type)
              ]
          ),

        ),
        borderRadius:BorderRadius.circular(70) ,
        radius: 70.0,
      ),
    );
  }

  void _onSave(){
    List<num> ids = this.billTypes.where((element) => element.isSelect).map((e) => e.id).toList();
    BillTypeService().selectAll(ids).then((value) => {
      Navigator.pop(context)
    });
  }

}