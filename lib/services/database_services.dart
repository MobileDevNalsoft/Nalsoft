
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class DatabaseServices{
  final _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> readData(){
    final userCollection = FirebaseFirestore.instance.collection("Employees");

    return userCollection.snapshots().map((querySnapshot)
    => querySnapshot.docs.map((e)
    => UserModel.fromSnapshot(e)).toList());
  }

  readDepartments() async {
    final depts = await _db.collection('departments').doc('departments_nalsoft').get();
    return depts.data();
  }

  readFloors() async {
    final snapshot = await _db.collection('floors').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  void pushEmployeeData(String docID,UserModel userData) {
    print('pushing data');
    _db.collection('employees').doc(docID).set(userData.toJson());
  }

  // void _updateData(UserModel userModel){
  //   final userCollection = FirebaseFirestore.instance.collection("employees");
  //
  //   final newData = UserModel(_userName, _email, _employee_id, _password, _department, _floor, _isAdmin).toJson();
  //
  //   userCollection.doc(userModel._email).update(newData);
  // }
  //
  // void _deleteData(String id){
  //   final userCollection = FirebaseFirestore.instance.collection("employees");
  //
  //   userCollection.doc(id).delete();
  // }
}