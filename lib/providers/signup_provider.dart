import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:meals_management_with_firebase/services/database_services.dart";
import "package:meals_management_with_firebase/services/firebase_auth_services.dart";
import "../models/user_model.dart";

class SignupProvider extends ChangeNotifier {

  FirebaseAuthServices _auth = FirebaseAuthServices();
  DatabaseServices _db = DatabaseServices();

  String? _dept;
  String? _floor;

  void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void  setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

  String? get getDept => _dept;
  String? get getFloor => _floor;

  Future<bool> signUp(String userName,String email,String employee_id,String password) async{
    
    User? user = await _auth.signUpwithEmailandPassword(email, password);

    if(user!=null){
      final userData = UserModel(userName, email, employee_id, password, _dept!, _floor!, false, {'optedDates' : [], 'notOptedDates' : [], 'unSignedDates' : []});
      _db.pushEmployeeData(user.uid, userData);
      return true;
    }
    return false;
  }
}
