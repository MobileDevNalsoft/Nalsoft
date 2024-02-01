import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class UserEventsRepo {
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creates a new user document in firestore collection
  void createUser(String docID, UserModel userData) {
    // _db.collection('employees').doc(docID).set(userData.toJson());
  }

  Future<bool> pushOpted(String? uid) async {
    final ref = _db.collection('employees').doc(uid);
    var data = await ref.get();
    if (data
        .data()!['opted']
        .contains(DateTime.now().toString().substring(0, 10))) {
      return true;
    } else {
      ref.update({
        'opted':
            FieldValue.arrayUnion([DateTime.now().toString().substring(0, 10)])
      });
      return false;
    }
  }

  void pushNotOpted(Map<String, dynamic> dates) {
    final ref = _db.collection('employees').doc(_auth.currentUser!.uid);
    ref.update({'notOpted': dates});
  }

  //retrieves the user data from firestore collection
  // Future<UserModel> readData() async {
  //   final userCollection =
  //       await _db.collection("employees").doc(_auth.currentUser!.uid).get();
  //   return UserModel.fromSnapshot(userCollection);
  // }

  //retrieves list of departments from firestore doc
  Future<List<dynamic>> readDepartments() async {
    final depts =
        await _db.collection('departments').doc('departments_nalsoft').get();
    return depts.data()!.values.toList();
  }

  // retrieves list of floors and its details from firestore
  Future<List<Map<String, Map<String, dynamic>>>> readFloors() async {
    final snapshot = await _db.collection('floors').get();
    return snapshot.docs.map((doc) => {doc.id: doc.data()}).toList();
  }

  Future<List<dynamic>> readHolidays() async {
    final snapshot = await _db.collection('holidays').doc('holiday_list').get();
    return snapshot.data()!['dates'];
  }

  Future<List<Map<String, dynamic>>> readUsers() async {
    final userCollection = await _db.collection('employees').get();
    return userCollection.docs.map((e) => e.data()).toList();
  }

  // Future<UserModel> readDataWithID({String? empid}) async {
  //   final snapshot = await _db.collection('employees').get();
  //   Map<String, dynamic> docids = {};
  //   snapshot.docs.forEach((doc) {
  //     docids[doc.id] = doc.data()['employee_id'];
  //   });
  //   String? docid;
  //   for (var entry in docids.entries) {
  //     if (empid == entry.value) {
  //       docid = entry.key;
  //     }
  //   }

  //   final userCollection = await _db.collection("employees").doc(docid).get();
  //   return UserModel.fromSnapshot(userCollection);
  // }

  Future<List<dynamic>> getEmployees({String search = ''}) async {
    QuerySnapshot querySnapshot = await _db
        .collection('employees')
        .where('username', isGreaterThanOrEqualTo: search)
        .where('username', isLessThan: '${search}z')
        .orderBy('username')
        .get();
    return querySnapshot.docs
        .map((doc) => [doc['username'], doc['employee_id']])
        .toList();
  }
}
