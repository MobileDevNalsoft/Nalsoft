import 'package:flutter/material.dart';
import 'package:mess_management/Repositories/signup_repo.dart';
import 'package:mess_management/providers/user_signup_provider.dart';

class UserProvider extends ChangeNotifier {
  String _email = '';
  String _empId= '';
  String _empName = '';
  String _department = '';
  String _floor = '';
  String _password = '';
  Map<DateTime, String> _events = {};

  UserProvider(
      String this._email,String this._empId, String this._password, this._department, this._floor);

  Map<DateTime, String> get events => _events;

  void createUserDb(){
    SignUpRepo.createUserDb(_email,_empName,_department,_floor,_password);
  }
  
  void updateUser(String email, String empName, String department,
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
