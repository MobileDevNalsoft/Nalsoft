import 'package:flutter/material.dart';
import 'package:meals_management/services/database_service.dart';
import 'package:meals_management/services/user_authentication.dart';
import 'package:meals_management/views/models/user_model.dart';

class LoginProvider extends ChangeNotifier {
  // late UserModel _user;
  FirebaseAuthService _auth = FirebaseAuthService();
  DatebaseServices _db = DatebaseServices();

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
  
  // UserModel get user=>_user;
  bool get obscurePassword => _obscurePassword;
  int get getErrTxt => _errTxt;
  int get getPassErrTxt => _passErrTxt;

  Future<bool> loginUser(String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      print("auth done");
    // //  _user= await _db.getEmployeeData(user.uid);
    // //  print(_user.isAdmin);
    //  notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
