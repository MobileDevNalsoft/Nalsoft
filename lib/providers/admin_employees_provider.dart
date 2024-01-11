import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  final DatabaseServices _db = DatabaseServices();

  List<String> empList = [];

  void setEmpList(String deptName) async {
    empList = await _db.readEmployees(deptName);
    print(empList);
    notifyListeners();
  }

  List<String> get getEmpList => empList;
}
