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
    print(UserModel.fromSnapshot(userCollection));
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

  // retrieves list of
  Future<List<Map<String, dynamic>>> readEmployees() async {
    final snapshot = await _db.collection('employees').get();
    return snapshot.docs
        .map((doc) => {doc.id: doc.data()})
        .map((e) => e.values.first)
        .toList();
  }

  //push date to db from employee home provider
  Future<void> pushDatetoDB(
      {required DateTime date, required int radioValue, String? reason}) async {
    final docRef = _db.collection('employees').doc(_auth.currentUser!.uid);

    if (radioValue == 2) {
      docRef.update({
        'opted': [date],
      });
    } else {
      docRef.update({
        'notOpted': {date: reason},
      });
    }
  }

  // Future<void> pushDatetoDB(
  //     {required DateTime date, required int radioValue, String? reason}) async {
  //   final docRef = _db.collection('employees').doc(_auth.currentUser!.uid);
  //   Map<String, dynamic> events = await readEvents();
  //   List<DateTime> optedDates = [];
  //   Map<String, dynamic> notOptedDatesWithReason = {};

  //   if (events['opted'] != null) {
  //     for (var date in events['opted']) {
  //       optedDates.add(date.toDate());
  //     }
  //     optedDates.add(date);
  //   } else {
  //     optedDates.add(date);
  //   }

  //   if (events['notOpted'] != null) {
  //     events['notOpted'].forEach((key, value) {
  //       notOptedDatesWithReason[key] = value;
  //     });
  //     notOptedDatesWithReason['2024-01-13 00:00:00.000'] = reason;
  //   } else {
  //     notOptedDatesWithReason[date.toString()] = reason;
  //   }

  //   if (radioValue == 2) {
  //     docRef.update({
  //       'events': {
  //         'notOpted': notOptedDatesWithReason,
  //       },
  //     });
  //   } else {
  //     docRef.update({
  //       'events': {'opted': FieldValue.arrayUnion(optedDates)},
  //     });
  //   }
  // }

  // //get dates from db for all pages
  // Future<Map<String, dynamic>> readEvents() async {
  //   Map<String, dynamic> dates = await _db
  //       .collection('employees')
  //       .doc(_auth.currentUser!.uid)
  //       .get()
  //       .then((value) => value.data()!['events']);
  //   return dates;
  // }

  // void pushEvents(List<DateTime>? dates) async {
  //   DocumentReference employeeReference =
  //       _db.collection('employees').doc(_auth.currentUser!.uid);
  //   DocumentSnapshot employeeSnapshot =
  //       await _db.collection('employees').doc(_auth.currentUser!.uid).get();
  //   var currentDates = employeeSnapshot['events']['notOpted'];
  //   currentDates.add(dates);
  //   await employeeReference.update({'events.notOpted': currentDates[1]});
  // }

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
