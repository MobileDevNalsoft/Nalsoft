import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/repositories/firebase_auth_repo.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/models/user_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();
  final FirebaseAuthRepo _auth = FirebaseAuthRepo();

  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  String? _dept;
  String? _floor;
  List<dynamic> deptList = [];
  List<String> floorList = [];

  void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

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

  Future<void> setDeptandFloorList() async {
    deptList = await _db.readDepartments();
    List<Map<String, Map<String, dynamic>>> floorDetails =
        await _db.readFloors();
    floorList = floorDetails.map((e) => e.keys.first).toList();
    notifyListeners();
  }

  // creating user document in firestore collection
  Future<bool> createUser(String userName, String email, String employee_id,
      String password) async {
    User? user = await _auth.signUpwithEmailandPassword(email, password);
    if (user != null) {
      final userData = UserModel(
          userName, email, employee_id, _dept!, _floor!, false, [], {}, []);
      _db.createUser(user.uid, userData);
      return true;
    }
    return false;
  }

  // validating user login details
  Future<bool> userLogin(String email, String password) async {
    User? user = await _auth.signInwithEmailandPassword(email, password);
    if (user != null) {
      return true;
    }
    return false;
  }

  String? get getDept => _dept;
  String? get getFloor => _floor;
  bool get obscurePassword => _obscurePassword;
  int get getErrTxt => _errTxt;
  int get getPassErrTxt => _passErrTxt;
  List<dynamic> get getDeptList => deptList;
  List<String> get getFloorList => floorList;
}
