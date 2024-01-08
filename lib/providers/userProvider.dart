import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _email = '';
  String _empName = '';
  String _department = '';
  String _floor = '';
  String _password = '';
  Map<DateTime, String> _events = {};

  UserModel(
      String this._email, String this._password, this._department, this._floor);

  Map<DateTime, String> get events => _events;

  void _updateUser(String email, String empName, String department,
      String floor, String password) {
    _email = email;
    _department = department;
    _empName = empName;
    _floor = floor;
    _password = password;
  }

  void updateEvents(Map<DateTime, String> updatedEvents) {
    _events = updatedEvents;
    notifyListeners();
  }
}
