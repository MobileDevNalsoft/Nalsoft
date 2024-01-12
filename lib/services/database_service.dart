import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meals_management/views/models/user_model.dart';

class DatebaseServices {
  final _db = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

  createUser(UserModel user, String uId) async {
    await _db.collection('employees').doc(uId).set(user.toJson());
  }
  
  readFloorDetails(String id) async {
    final snapshot = await _db.collection('floors').doc(id).get();
    return snapshot.data();
  }

  //retrieves employee data
  Future<UserModel> getEmployeeData(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _db.collection("employees").doc(uid).get();
    print(documentSnapshot);
    UserModel user = UserModel.fromSnapshot(
        documentSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    return user;
  }

  //List of departments from db
  Future getDepartments() async {
    // QuerySnapshot snapshot = await _db.collection('departments').get();
    // List<Map<String, dynamic>> deptList =
    //     snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    // return deptList;
    DocumentSnapshot documentSnapshot =
        await _db.collection('departments').doc('departments_nalsoft').get();
    return documentSnapshot.data();
  }

  // List of floors from db
  getFloors() async {
    QuerySnapshot querySnapshot = await _db.collection('floors').get();
    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  getEmployees() async{
    QuerySnapshot querySnapshot = await _db.collection('employees').where('username',isGreaterThanOrEqualTo: 'ab').where('username',isLessThan: 'abz').get();
    print(querySnapshot.docs.map((doc) => doc.data()).toList());
    
    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  }
