
import 'package:bill/view/maomi/index.dart';
import 'package:bill/view/yyets/ui/pages/DetailPage.dart';
import 'package:bill/view/yyets/ui/pages/DownloadManagerPage.dart';
import 'package:bill/view/yyets/ui/pages/FavoritesPage.dart';
import 'package:bill/view/yyets/ui/pages/LatestResourcePage.dart';
import 'package:bill/view/yyets/ui/pages/LoginPage.dart';
import 'package:bill/view/yyets/ui/pages/MainPage.dart';
import 'package:bill/view/yyets/ui/pages/ResInfoPage.dart';
import 'package:bill/view/yyets/ui/pages/VideoPlayerPage.dart';
import 'package:bill/view/yyets/ui/pages/VideoPlayerPage2.dart';
import 'package:bill/view/yyets/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:bill/view/add/BillAdd.dart';
import 'package:bill/view/index/index.dart';
import 'package:bill/view/theme/ThemeChangeRoute.dart';

class Routes{
  final Map<String, WidgetBuilder> routes = {};
  BuildContext c;

  Routes(this.c);

  Map<String, WidgetBuilder> init(){
    return {
      '/' : (c) => Index(),
      'bill_add' : (c) => BillAdd(),
      'themes': (c) => ThemeChangeRoute(),
      'maomi': (c) => Maomi(),
      // "/": (c) => MyHomePage(),
      "/detail": (c) => DetailPage(argsFromContext(c)),
      "/res": (c) => ResInfoPage(argsFromContext(c)),
      "/favorites": (c) => FavoritesPage(),
      "/login": (c) => LoginPage(),
//  "/register": (c) => RegisterPage(),
      "/download": (c) => DownloadManagerPage(),
      "/play": (c) => (PlatformExt.isMobilePhone)
          ? VideoPlayerPage(argsFromContext(c))
          : VideoPlayerPageForWeb(argsFromContext(c)),
      "/latest": (c) => LatestResourcePage()
    };
  }

  dynamic argsFromContext(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }
}