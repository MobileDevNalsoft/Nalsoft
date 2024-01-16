import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/repositories/user_events_repo.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String,dynamic>> _empData = [];

  Future<void> setEmpData() async {
    _empData = await _db.readEmployees();
    notifyListeners();
  }

  List<Map<String,dynamic>> get getEmpData => _empData;
}
