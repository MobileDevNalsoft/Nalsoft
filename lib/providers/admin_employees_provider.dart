import 'package:flutter/material.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String, dynamic>> _empData = [];
  List<dynamic> empList = [];
  bool _isSearching = false;

  set isSearching(value) {
    _isSearching = value;
    notifyListeners();
  }

  Future<void> setEmpList({String search = ''}) async {
    var allEmpinfoList = await _db.getEmployees(search: search);
    empList = allEmpinfoList;
    isSearching = false;
    notifyListeners();
  }

  Future<void> setEmpData() async {
    _empData = await _db.readEmployees();
    notifyListeners();
  }

  List<Map<String, dynamic>> get getEmpData => _empData;
  List<dynamic> get getEmpList => empList;
  get isSearching => _isSearching;
}
