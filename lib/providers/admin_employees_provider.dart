import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  DatabaseServices _db = DatabaseServices();

  List<String> deptEmpList = [];

  void setEmpList(String deptName) async {
    deptEmpList = [];
    var empList = await _db.readEmployees(deptName);
    for (var map in empList) {
      deptEmpList.add(map['username']);
    }
    ;
    notifyListeners();
  }

  List<String> get getEmpList => deptEmpList;
}
