import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userName;
  String _email;
  String _employee_id;
  String _department;
  String floor;
  bool _isAdmin = false;

  UserModel(this.userName, this._email, this._employee_id, this._department,
      this.floor, this._isAdmin);

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
        snapshot['username'],
        snapshot['email'],
        snapshot['employee_id'],
        snapshot['department'],
        snapshot['floor'],
        snapshot['isAdmin']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': _email,
      'employee_id': _employee_id,
      'department': _department,
      'floor': floor,
      'isAdmin': _isAdmin,
    };
  }
}
