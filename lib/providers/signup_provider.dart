import "package:flutter/material.dart";

class SignupProvider extends ChangeNotifier {
  String _dept = 'Department';
  String _floor = 'Floor';

  void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void  setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

  String get getDept => _dept;
  String get getFloor => _floor;
}
