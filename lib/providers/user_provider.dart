import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meals_management/services/database_service.dart';
import 'package:meals_management/services/user_authentication.dart';
import 'package:meals_management/views/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel('', '', '', '', '', false);
  FirebaseAuthService _auth = FirebaseAuthService();
  DatebaseServices _db = DatebaseServices();

  String? _dept;
  String? _floor;
  String? get getDept => _dept;
  String? get getFloor => _floor;
  UserModel get user => _user;
  List<String>? deptList;
  List<String>? floorList;

  void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

  setDeptandFloorList() async {
    deptList = await _db.getDepartments();
    floorList = await _db.getFloors();
    notifyListeners();
  }

  Future<bool> signUpUser(
    String username,
    String email,
    String empId,
    String password,
  ) async {
    final user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null) {
      _user = UserModel(email, username, empId, _dept!, _floor!, false);
      _db.createUser(_user, user.uid);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    final authUser = await _auth.signInWithEmailAndPassword(email, password);
    if (authUser != null) {
      print("auth done");
      setUser();
      return true;
    } else {
      return false;
    }
  }

  void setUser()async {
    _user=await _db.getEmployeeData(FirebaseAuth.instance.currentUser!.uid);
    print("username: ${_user.username}");
    notifyListeners();
  }

    void removeUser()async {
    _user= UserModel('', '', '', '', '', false);
    notifyListeners();
  }
}
