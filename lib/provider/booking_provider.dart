import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier{
  int screenNumber = 3;
  int planeNumber = 1;
  int totalPassengers = 0;
  int adults = 2;
  int teenagers = 0;
  int babies = 0;
  int totalSeatSelected = 0;

  void changeScreenNumber(int value){
    screenNumber = value;
    notifyListeners();
  }

  void changePassengers(int adults,int teenagers, int babies){
    totalPassengers = adults + teenagers + babies;
    this.adults = adults;
    this.teenagers = teenagers;
    this.babies = babies;
    notifyListeners();
  }


}