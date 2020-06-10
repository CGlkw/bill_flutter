import 'package:bill/view/yyets/model/RRUser.dart';
import 'package:flutter/material.dart';
import 'package:bill/common/Global.dart';
import 'package:bill/routes/Routes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
//Global.init().then((e) => runApp(MyApp()));

void main() =>  runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  {
    return OKToast(
      child:  MultiProvider(
        providers: [
          ChangeNotifierProvider(create:(_)=> ThemeModel()),
          ChangeNotifierProvider(create: (_) => RRUser()),
        ],
        child: Consumer<ThemeModel>(
          builder: (BuildContext context, themeModel, Widget child){
            return MaterialApp(
              title: 'Bill',
              theme: ThemeData(
                primarySwatch: themeModel.theme,
              ),
              initialRoute: '/',
              routes: Routes(context).init(),
            );
          },
        ),
      ),
    );
  }
}
