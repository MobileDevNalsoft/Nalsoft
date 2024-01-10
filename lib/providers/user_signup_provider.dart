import "package:flutter/material.dart";
import "package:meals_management/services/database_service.dart";
import "package:meals_management/services/user_authentication.dart";
import "package:meals_management/views/modals/user_model.dart";

class SignUpProvider extends ChangeNotifier {
  UserModel? _user;
  FirebaseAuthService _auth = FirebaseAuthService();
  DatebaseServices _db = DatebaseServices();

  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  bool get obscurePassword => _obscurePassword;

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

  UserModel? get user => _user;

  Future<bool> signUpUser(String email, String empId, String password,
      String department, String floor) async {
    final user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null) {
      _user = UserModel(email, empId, password, department, floor);
      _db.createUser(_user!, user.uid);
      return true;
    } else {
      return false;
    }

  }

}
