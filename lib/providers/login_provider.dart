
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier{
  bool _obscurePassword = true;

  void obscureToggle(){
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool get obscurePassword => _obscurePassword;
}