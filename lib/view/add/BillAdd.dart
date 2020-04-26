
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BillAdd extends StatefulWidget{
  @override
  _BillAddState createState() => _BillAddState();
}

class _BillAddState extends State<BillAdd>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Add')
      ),
      body:Container(
        alignment: Alignment.center,
        child: Text('Bill Add'),
      )
    );
    
  }
}