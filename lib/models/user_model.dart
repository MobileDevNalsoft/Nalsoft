import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userName;
  String email;
  String employee_id;
  String department;
  String floor;
  bool isAdmin;
  Map<String ,dynamic> opted;
  Map<String, dynamic> notOpted;

  UserModel(this.userName, this.email, this.employee_id, this.department,
      this.floor, this.isAdmin, this.opted, this.notOpted);

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
        snapshot['username'],
        snapshot['email'],
        snapshot['employee_id'],
        snapshot['department'],
        snapshot['floor'],
        snapshot['isAdmin'],
        snapshot['opted'],
        snapshot['notOpted']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': email,
      'employee_id': employee_id,
      'department': department,
      'floor': floor,
      'isAdmin': isAdmin,
      'opted': opted,
      'notOpted': notOpted,
    };
  }
}
