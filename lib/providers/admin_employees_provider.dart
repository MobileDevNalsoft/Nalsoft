import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  DatabaseServices _db = DatabaseServices();

  List<Map<String, dynamic>> empList = [];

  void setEmpList() async {
    empList = await _db.readEmployees();
    notifyListeners();
  }
}
