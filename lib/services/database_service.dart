import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meals_management/views/models/user_model.dart';

class DatebaseServices {
  final _db = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

  createUser(UserModel user, String uId) async {
    await _db.collection('employees').doc(uId).set(user.toJson());
  }

readData() async {
    final userCollection =
        await _db.collection("employees").doc(_auth.currentUser!.uid).get();
    return UserModel.fromSnapshot(userCollection);
  }
  
  readFloorDetails(String id) async {
    final snapshot = await _db.collection('floors').doc(id).get();
    return snapshot.data();
  }
  Future<UserModel> getEmployeeData(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _db.collection("employees").doc(uid).get();
    print(documentSnapshot);

    if (documentSnapshot.exists) {
      print("yes");
    } else {
      print("no");
    }
    UserModel user = UserModel.fromSnapshot(
        documentSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    return user;
   
  }

  Future<List<Map<String, dynamic>>> getDepartments() async {
    QuerySnapshot snapshot = await _db.collection('departments').get();
    List<Map<String, dynamic>> deptList =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    return deptList;
  }

  readDepartments() async {
    final depts =
        await _db.collection('departments').doc('departments_nalsoft').get();
    return depts.data();
  }

  readFloors() async {
    final snapshot = await _db.collection('floors').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }
  }
