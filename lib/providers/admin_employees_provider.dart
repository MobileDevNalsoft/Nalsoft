import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  final DatabaseServices _db = DatabaseServices();

  List<Map<String, dynamic>> deptEmpList = [];

  void setEmpList(String deptName) async {
    deptEmpList = await _db.readEmployees(deptName);
    print(deptEmpList);
    notifyListeners();
  }

  List<Map<String, dynamic>> get getEmpList => deptEmpList;
}
