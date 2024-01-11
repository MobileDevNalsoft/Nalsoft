import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AuthProvider extends ChangeNotifier {
  final DatabaseServices _db = DatabaseServices();

  bool _obscurePassword = true;
  List<dynamic> deptList = [];
  List<String> floorList = [];

  void obscureToggle() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> setDeptandFloorList() async {
    deptList = await _db.readDepartments();
    List<Map<String, Map<String, dynamic>>> floorDetails =
        await _db.readFloors();
    floorList = floorDetails.map((e) => e.keys.first).toList();
    notifyListeners();
  }

  bool get obscurePassword => _obscurePassword;
  List<dynamic> get getDeptList => deptList;
  List<String> get getFloorList => floorList;
}
