import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpRepo{

static void createUserDb(String email,String empName,String department,String floor,String password){
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');

     employeeCollection.add({
      'email': email,
      'department': department,
      'floor': floor,
      'isAdmin':false,
    });
  }

}
  
