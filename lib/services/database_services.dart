
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class DatebaseServices{
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection('Employees').doc("1").set(user.toJson());
  }

  Stream<List<UserModel>> _readData(){
    final userCollection = FirebaseFirestore.instance.collection("Employees");

    return userCollection.snapshots().map((querySnapshot)
    => querySnapshot.docs.map((e)
    => UserModel.fromSnapshot(e)).toList());
  }

  Future<List<Map<String,dynamic>>> getDepartments() async{
    QuerySnapshot snapshot = await _db.collection('departments').get();

    List<Map<String,dynamic>> deptList = snapshot.docs.map((doc) => doc.data() as Map<String,dynamic>).toList();

    return deptList;
  }
}