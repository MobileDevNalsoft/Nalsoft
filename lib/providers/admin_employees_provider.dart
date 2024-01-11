import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  final DatabaseServices _db = DatabaseServices();

  List<dynamic> empList = [];

  Future<void> setEmpList() async {
    var allEmpinfoList = await _db.readEmployees();
    empList = allEmpinfoList.map((e) => e['username']).toList();
    notifyListeners();
  }

  List<dynamic> get getEmpList => empList;
}
