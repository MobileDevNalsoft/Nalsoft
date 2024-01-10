import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AdminHomeProvider extends ChangeNotifier {
  DatabaseServices _db = DatabaseServices();

  List<dynamic> deptList = [];

  void setDeptList() async {
    deptList = await _db.readDepartments();
    notifyListeners();
  }

  List<dynamic> get getDeptList => deptList;
}
