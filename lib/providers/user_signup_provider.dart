import "package:flutter/material.dart";
import "package:meals_management/services/database_service.dart";
import "package:meals_management/services/user_authentication.dart";
import 'package:meals_management/views/models/user_model.dart';

class SignUpProvider extends ChangeNotifier {
  UserModel? _user= UserModel('', '', '', '', '', false);
  FirebaseAuthService _auth = FirebaseAuthService();
  DatebaseServices _db = DatebaseServices();
  String? _dept;
  String? _floor;
  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  bool get obscurePassword => _obscurePassword;
  List<String>? deptList;
  List<String>? floorList;
  // void obscureToggle() {
  //   _obscurePassword = !_obscurePassword;
  //   notifyListeners();
  // }

  // void setErrTxt(int value) {
  //   _errTxt = value;
  //   notifyListeners();
  // }

  // void setPassErrTxt(int value) {
  //   _passErrTxt = value;
  //   notifyListeners();
  // }

   void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void  setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }
  setDeptandFloorList() async{
     deptList = await _db.readDepartments();
    floorList = await _db.readFloors();
    notifyListeners();
  }

  UserModel? get user => _user;
 String? get getDept => _dept;
  String? get getFloor => _floor;

  Future<bool> signUpUser(String username,String email, String empId, String password,
      ) async {
    final user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null) {
      _user = UserModel(email,username,empId, _dept!, _floor!,false);
      _db.createUser(_user!, user.uid);
      return true;
    } else {
      return false;
    }

  }

}
