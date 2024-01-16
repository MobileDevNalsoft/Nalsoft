import 'package:flutter/material.dart';
import 'package:meals_management/Repositories/user_events_repo.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  final UserEventsRepo _db = UserEventsRepo();

  List<dynamic> deptList = [];
  List<String> floorList = [];

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
  Future<void> setDeptandFloorList() async {
    deptList = await _db.readDepartments();
    List<Map<String, Map<String, dynamic>>> floorDetails =
        await _db.readFloors();
    floorList = floorDetails.map((e) => e.keys.first).toList();
    notifyListeners();
  }

  List<dynamic> get getDeptList => deptList;
  List<String> get getFloorList => floorList;
}
