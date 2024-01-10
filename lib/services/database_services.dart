import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meals_management_with_firebase/models/events_model.dart';
import '../models/user_model.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> readData() async {
    final userCollection =
        await _db.collection("employees").doc(_auth.currentUser!.uid).get();
    return UserModel.fromSnapshot(userCollection);
  }

  readEmployees(String deptName) async {

    return await _db
        .collection('employees')
        .where('department', isEqualTo: deptName)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.map((doc) => doc.data()).toList());
  }

  readDepartments() async {
    final depts =
        await _db.collection('departments').doc('departments_nalsoft').get();
    return depts.data()!.values.toList();
  }

  readFloors() async {
    final snapshot = await _db.collection('floors').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  readFloorDetails(String id) async {
    final snapshot = await _db.collection('floors').doc(id).get();
    return snapshot.data();
  }

  void pushEmployeeData(String docID, UserModel userData) {
    _db.collection('employees').doc(docID).set(userData.toJson());
  }

  // void pushEventDates(EventsModel events){
  //   _db.collection('employees').doc(_auth.currentUser!.uid).collection(_auth.currentUser!.uid).doc('events').set(events.toJson());
  // }

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