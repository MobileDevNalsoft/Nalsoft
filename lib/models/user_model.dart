
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String email;
  String employee_id;
  String password;
  String department;
  String floor;

  UserModel(
    this.email,
    this.employee_id,
    this.password,
    this.department,
    this.floor,
  );

  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    return UserModel(
      snapshot['email'],
      snapshot['employee_id'],
      snapshot['password'],
      snapshot['department'],
      snapshot['floor']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'employee_id': employee_id,
      'password': password,
      'department': department,
      'floor': floor,
    };
    return data;
  }

  void _updateData(UserModel userModel){
    final userCollection = FirebaseFirestore.instance.collection("Employees");

    final newData = UserModel(email, employee_id, password, department, floor).toJson();

    userCollection.doc(userModel.email).update(newData);
  }

  void _deleteData(String id){
    final userCollection = FirebaseFirestore.instance.collection("Employees");

    userCollection.doc(id).delete();
  }
}