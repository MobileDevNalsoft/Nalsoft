import 'package:flutter/material.dart';

class UniversalDataProvider extends ChangeNotifier {
  String? _deptNameforEmployeesPage;

  void setDeptNameforEmployeesPage(String? deptName) {
    _deptNameforEmployeesPage = deptName;
    notifyListeners();
  }

  String? get getDDeptNameforEmployeesPage => _deptNameforEmployeesPage;
}
