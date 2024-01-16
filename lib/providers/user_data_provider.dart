import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/repositories/firebase_auth_repo.dart';

class UserDataProvider extends ChangeNotifier {
  final FirebaseAuthRepo _auth = FirebaseAuthRepo();
  final UserEventsRepo _db = UserEventsRepo();

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
    if (user != null) {
      final userData = UserModel(
          userName, email, employee_id, _dept!, _floor!, false, [], {}, []);
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
