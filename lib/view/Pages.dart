import 'package:flutter/cupertino.dart';

abstract class Pages{

  Pages init();

  PreferredSizeWidget getAppBar();

  Widget getBody();
}