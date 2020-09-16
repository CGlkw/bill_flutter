import 'package:bill/common/BillIcon.dart';
import 'package:flutter/material.dart';

class TestHero extends StatelessWidget{

  Map name;


  TestHero(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TestHero"),
      ),
      body: Center(
        child: Hero(
          tag: name['icon'],
          child: Icon(BillIcons.all[name['icon']],size: 18,),
        ),
      ),
    );
  }

}