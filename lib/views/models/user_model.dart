
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String email;
  String username;
  String employee_id;
  String department;
  String floor;
  bool isAdmin;

  UserModel(
    this.email,
    this.username,
    this.employee_id,
    this.department,
    this.floor,
    this.isAdmin,
  );

  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    return UserModel(
      snapshot['email'],
      snapshot['username'],
      snapshot['employee_id'],
      snapshot['department'],
      snapshot['floor'],
      snapshot['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'username':username,
      'employee_id': employee_id,
      'department': department,
      'floor': floor,
      'isAdmin':false,
    };
    return data;
  }
}