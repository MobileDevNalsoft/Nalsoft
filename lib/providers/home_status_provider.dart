import 'package:flutter/material.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class HomeStatusProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String, Map<String, dynamic>>> _floorDetails = [];
  bool _reasonStatusEmpty = false;
  String _selectedReason = 'Single day';
  int? _employeeCount;

  void setReasonStatusEmpty(bool value) {
    _reasonStatusEmpty = value;
    notifyListeners();
  }

  void setReason(String value) {
    _selectedReason = value;
    notifyListeners();
  }

  void setEmployeeCount(int value) {
    _employeeCount = value;
    notifyListeners();
  }

  void incrEmpCount() {
    _employeeCount = _employeeCount! + 1;
    notifyListeners();
  }



  bool get getReasonStatusEmpty => _reasonStatusEmpty;
  String get getReason => _selectedReason;
  List<Map<String, Map<String, dynamic>>> get getFloorDetails => _floorDetails;
  int? get getEmployeeCount => _employeeCount;
}
