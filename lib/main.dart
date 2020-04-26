import 'package:flutter/material.dart';
import 'package:bill/common/Global.dart';
import 'package:bill/routes/Routes.dart';
import 'package:provider/provider.dart';
// import './view/blend_state/ParentWidgetC.dart';
import 'view/index/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(notifier: ThemeModel()),
      ],
      child: Consumer<ThemeModel>(
        builder: (BuildContext context, themeModel, Widget child){
          return MaterialApp(
            title: 'Bill',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: themeModel.theme,
            ),
            initialRoute: '/',
            routes: Routes(context).init(),
          );
        },  
      ),
    );
  }
}
