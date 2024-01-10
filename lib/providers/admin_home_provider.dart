import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/models/user_model.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class AdminHomeProvider extends ChangeNotifier {
  DatabaseServices _db = DatabaseServices();

  List<dynamic> deptList = [];
  UserModel? _user;

  void setDeptList() async {
    deptList = await _db.readDepartments();
    notifyListeners();
  }

  void setUser() async {
    _user = await _db.readData();
    notifyListeners();
  }

  List<dynamic> get getDeptList => deptList;
  UserModel? get getUser => _user!;
}
