import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/models/user_model.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';
import 'package:meals_management_with_firebase/services/firebase_auth_services.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final DatabaseServices _db = DatabaseServices();

  // for UI updations
  String? _dept;
  String? _floor;
  UserModel? user;

  void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

  // getting user data from firestore collection
  Future<void> setUser() async {
    user = await _db.readData();
    notifyListeners();
  }

  String? get getDept => _dept;
  String? get getFloor => _floor;
  UserModel? get getUser => user;

  // creating user document in firestore collection
  Future<bool> createUser(String userName, String email, String employee_id,
      String password) async {
    User? user = await _auth.signUpwithEmailandPassword(email, password);
    print(_dept);
    if (user != null) {
      final userData = UserModel(userName, email, employee_id, _dept!, _floor!,
          false, {'opted': [], 'notOpted': [], 'unSigned': []});
      _db.createUser(user.uid, userData);
      return true;
    }
    return false;
  }

  // validating user login details
  Future<bool> userLogin(String email, String password) async {
    User? user = await _auth.signInwithEmailandPassword(email, password);
    if (user != null) {
      return true;
    }
    return false;
  }
}
