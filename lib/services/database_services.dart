import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creates a new user document in firestore collection
  Future<void> createUser(String docID, UserModel userData) async {
    await _db.collection('employees').doc(docID).set(userData.toJson());
  }

  //retrieves the user data from firestore collection
  Future<UserModel> readData() async {
    final userCollection =
        await _db.collection("employees").doc(_auth.currentUser!.uid).get();
    return UserModel.fromSnapshot(userCollection);
  }

  Future<List<dynamic>> readDepartments() async {
    final depts =
        await _db.collection('departments').doc('departments_nalsoft').get();
    return depts.data()!.values.toList();
  }

  Future<List<Map<String, Map<String, dynamic>>>> readFloors() async {
    final snapshot = await _db.collection('floors').get();
    return snapshot.docs.map((doc) => {doc.id: doc.data()}).toList();
  }

  readEmployees(String deptName) async {
    return await _db
        .collection('employees')
        .where('department', isEqualTo: deptName)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.map((doc) => doc.data()).toList());
  }

  void pushEvents(List<DateTime>? dates) async {
    DocumentReference employeeReference =
        _db.collection('employees').doc(_auth.currentUser!.uid);
    DocumentSnapshot employeeSnapshot =
        await _db.collection('employees').doc(_auth.currentUser!.uid).get();
    var currentDates = employeeSnapshot['events']['notOpted'];
    currentDates.add(dates);
    await employeeReference.update({'notOpted': currentDates[1]});
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
