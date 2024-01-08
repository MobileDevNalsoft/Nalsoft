import "package:flutter/material.dart";

class UserRegistrationModel extends ChangeNotifier {
  String _email = '';
  String _name = '';
  int _empId = 0;
  String _dept = '';
  int _floor = 0;
  String _password = '';

  UserRegistrationModel();

  set setEmail(String email) {
    _email = email;
  }

  // set setName(String name) {
  //   _name = name;
  // }

  set setEmpId(int empId) {
    _empId = empId;
  }

  set setDept(String dept) {
    _dept = dept;
  }

  set setFloor(int floor) {
    _floor = floor;
  }

  set setPassword(String password) {
    _password = password;
  }

  String get email => _email;
  // String get name => _name;
  int get empId => _empId;
  String get dept => _dept;
  int get floor => _floor;
  String get password => _password;

  void registerUser() {}
}
