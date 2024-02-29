import 'package:flutter/material.dart';
import 'package:meals_management/repositories/auth_repo.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationRepo? authenticationRepo;
  AuthenticationProvider({this.authenticationRepo});

  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;

  void obscureToggle() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setErrTxt(int value) {
    _errTxt = value;
    notifyListeners();
  }

  void setPassErrTxt(int value) {
    _passErrTxt = value;
    notifyListeners();
  }

  Future getToken(email, pass, context) async {
    await authenticationRepo!.gettoken(email, pass, context);
  }

  bool get obscurePassword => _obscurePassword;
  int get getErrTxt => _errTxt;
  int get getPassErrTxt => _passErrTxt;

  String getUserToken() {
    return authenticationRepo!.getUserToken();
  }

  String getAuthToken() {
    return authenticationRepo!.getAuthToken();
  }
}
