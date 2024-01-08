
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
}