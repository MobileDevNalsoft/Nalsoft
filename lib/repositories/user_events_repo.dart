import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class UserEventsRepo {
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

  Future<void> pushOpted(Map<String, dynamic> dates) async {
    final ref = _db.collection('employees').doc(_auth.currentUser!.uid);
    ref.update({'opted': dates});
  }

  Future<void> pushNotOpted(Map<String, dynamic> dates) async {
    final ref = _db.collection('employees').doc(_auth.currentUser!.uid);
    ref.update({'notOpted': dates});
  }

  Future<List<Map<String, dynamic>>> readUsers() async {
    final userCollection = await _db.collection('employees').get();
    return userCollection.docs.map((e) => e.data()).toList();
  }

  Future<UserModel> readDataWithID({String? empid}) async {
    final snapshot = await _db.collection('employees').get();
    List<Map<String, dynamic>> docids =
        snapshot.docs.map((e) => {e.id: e.data()['employee_id']}).toList();
    String? docid;
    for (var item in docids) {
      if (empid == item.values.first) {
        docid = item.keys.first;
      }
    }

    final userCollection = await _db.collection("employees").doc(docid).get();
    return UserModel.fromSnapshot(userCollection);
  }

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

  //push date to db from employee home provider
  Future<void> pushDatetoDB(
      {required DateTime date,
      required int radioValue,
      String? reason,
      String? url}) async {
    final docRef = _db.collection('employees').doc(_auth.currentUser!.uid);
    Map<String, dynamic>? data =
        await docRef.get().then((value) => value.data());
    // var date = DateTime.parse('2024-01-16 00:00:00.000');

    if (radioValue == 2) {
      if (data!['opted'].keys.contains(date.toString())) {
        data['opted'].remove(date.toString());
        docRef.update({
          'opted': data['opted'],
        });
      }
      if (data['notOpted'].keys.contains(date.toString())) {
        data['notOpted'].remove(date.toString());
        docRef.update({'notOpted': data['notOpted']});
      }
      data['notOpted'][date.toString()] = reason;
      docRef.update({'notOpted': data['notOpted']});
    } else {
      if (data!['notOpted'].keys.contains(date.toString())) {
        data['notOpted'].remove(date.toString());
        docRef.update({'notOpted': data['notOpted']});
      }
      if (data['opted'].keys.contains(date.toString())) {
        data['opted'].remove(date.toString());
        docRef.update({
          'opted': data['opted'],
        });
      }
      data['opted'][date.toString()] = url;
      docRef.update({
        'opted': data['opted'],
      });
    }
  }

  Future<void> pushDatestoDB(
      {required List<DateTime> dates,
      required int radioValue,
      String? reason}) async {
    final docRef = _db.collection('employees').doc(_auth.currentUser!.uid);
    Map<String, dynamic>? data =
        await docRef.get().then((value) => value.data());
    for (var date in dates) {
      if (data!['notOpted'].keys.contains(date.toString())) {
        data['notOpted'].remove(date.toString());
        docRef.update({'notOpted': data['notOpted']});
      }
      data['notOpted'][date.toString()] = reason;
      docRef.update({'notOpted': data['notOpted']});
    }
  }

  Future<Map<DateTime, String>> readNotOptedWithReasons() async {
    Map<String, dynamic> dates = await _db
        .collection('employees')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => value.data()!['notOpted']);
    Map<DateTime, String> dateReasons = {};
    dates.forEach((key, value) {
      dateReasons[DateTime.parse(key)] = value.toString();
    });
    return dateReasons;
  }

  //get opted dates from db for all pages
  Future<List<DateTime>> readOptedWithID({String? empid}) async {
    final snapshot = await _db.collection('employees').get();
    List<Map<String, dynamic>> docids =
        snapshot.docs.map((e) => {e.id: e.data()['employee_id']}).toList();
    String? docid;
    for (var item in docids) {
      if (empid == item.values.first) {
        docid = item.keys.first;
      }
    }

    List<dynamic> dates = await _db
        .collection('employees')
        .doc(docid)
        .get()
        .then((value) => value.data()!['opted']);
    List<DateTime> dateTimelist = dates.map((e) => DateTime.parse(e)).toList();
    return dateTimelist;
  }

  //get notopted dates from db for all pages
  Future<List<DateTime>> readNotOptedWithID({String? empid}) async {
    final snapshot = await _db.collection('employees').get();
    List<Map<String, dynamic>> docids =
        snapshot.docs.map((e) => {e.id: e.data()['employee_id']}).toList();
    String? docid;
    for (var item in docids) {
      if (empid == item.values.first) {
        docid = item.keys.first;
      }
    }

    List<dynamic> dates = await _db
        .collection('employees')
        .doc(docid)
        .get()
        .then((value) => value.data()!['notOpted'].keys.toList());
    List<DateTime> dateTimelist = dates.map((e) => DateTime.parse(e)).toList();
    return dateTimelist;
  }

  Future<Map<DateTime, String>> readNotOptedWithReasonsWithID(
      {String? empid}) async {
    final snapshot = await _db.collection('employees').get();
    List<Map<String, dynamic>> docids =
        snapshot.docs.map((e) => {e.id: e.data()['employee_id']}).toList();
    String? docid;
    for (var item in docids) {
      if (empid == item.values.first) {
        docid = item.keys.first;
      }
    }

    Map<String, dynamic> dates = await _db
        .collection('employees')
        .doc(docid)
        .get()
        .then((value) => value.data()!['notOpted']);
    Map<DateTime, String> dateReasons = {};
    dates.forEach((key, value) {
      dateReasons[DateTime.parse(key)] = value.toString();
    });
    return dateReasons;
  }

  Future<void> removeDateFromDb(DateTime date) async {
    final docRef = _db.collection('employees').doc(_auth.currentUser!.uid);
    Map<String, dynamic>? data =
        await docRef.get().then((value) => value.data());

    data!['notOpted'].remove(date.toString());
    docRef.update({'notOpted': data['notOpted']});
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
