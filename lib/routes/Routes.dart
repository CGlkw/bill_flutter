
import 'package:bill/view/maomi/index.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/add/BillAdd.dart';
import 'package:bill/view/index/index.dart';
import 'package:bill/view/theme/ThemeChangeRoute.dart';

class Routes{
  final Map<String, WidgetBuilder> routes = {};
  BuildContext context;

  Routes(this.context);

  Map<String, WidgetBuilder> init(){
    return {
      '/' : (context) => Index(),
      'bill_add' : (context) => BillAdd(),
      'themes': (context) => ThemeChangeRoute(),
      'maomi': (context) => Maomi(),
    };
  }
}