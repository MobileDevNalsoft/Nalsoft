import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meals_management/views/models/dept_model.dart';

class AdminRepo{
   final _db = FirebaseFirestore.instance;
   
   Future<Department > getDepartments() async{
      DocumentSnapshot<Map<String,dynamic>> documentSnapshot= await _db.collection("departments").doc("departments_nalsoft").get() ;
      print("depts ${documentSnapshot.data() }");
      return Department( departments: documentSnapshot.data()!.values.toList() );
      
  
  }
}