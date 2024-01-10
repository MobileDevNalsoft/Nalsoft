import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:meals_management_with_firebase/services/database_services.dart";
import "package:meals_management_with_firebase/services/firebase_auth_services.dart";
import "../models/user_model.dart";

class SignupProvider extends ChangeNotifier {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final DatabaseServices _db = DatabaseServices();

  List<dynamic> deptList = [];
  List<String> floorList = [];
  String? _dept;
  String? _floor;

  void setDeptandFloorList() async {
    deptList = await _db.readDepartments();
    floorList = await _db.readFloors();
    notifyListeners();
  }

  void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

  String? get getDept => _dept;
  String? get getFloor => _floor;
  List<dynamic> get getDeptList => deptList;
  List<String> get getFloorList => floorList;

  Future<bool> signUp(String userName, String email, String employee_id,
      String password) async {
    User? user = await _auth.signUpwithEmailandPassword(email, password);

    if (user != null) {
      final userData =
          UserModel(userName, email, employee_id, _dept!, _floor!, false, {'opted' : [], 'notOpted' : [], 'unSigned' : []});
      _db.pushEmployeeData(user.uid, userData);
      return true;
    }
    return false;
  }
}
