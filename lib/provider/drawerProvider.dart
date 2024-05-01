import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerProvider extends ChangeNotifier{
  int screenNumber = 3; //web
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  void changeShow(int value){
    screenNumber = value;
    notifyListeners();

  }

  String screenName = "Customers" ;

  void changeScreen(String name){
    screenName = name;
    notifyListeners();
  }
}