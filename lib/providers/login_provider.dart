
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier{
  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;

  void obscureToggle(){
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setErrTxt(int value){
    _errTxt = value;
    notifyListeners();
  }

  void setPassErrTxt(int value){
    _passErrTxt = value;
    notifyListeners();
  }

  bool get obscurePassword => _obscurePassword;
  int get getErrTxt => _errTxt;
  int get getPassErrTxt => _passErrTxt;
}