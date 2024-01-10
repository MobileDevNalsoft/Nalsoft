import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepo{
static void createUserDb(String uId,String email,String empName,String department,String floor){
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');
      //  print("employeeeees ${employeeCollection.snapshots.}");
     employeeCollection.doc(uId).set({
      'email': email,
      'department': department,
      'floor': floor,
      'isAdmin':false,
      'events':{"opted":[],"notOpted":[],"unSigned":[],"leave":[]},
    });
  }
static void updateUserDb(String uId,String email,String empName,String department,String floor){
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');
     
     employeeCollection.doc(uId).set({
      'email': email,
      'department': department,
      'floor': floor,
      'isAdmin':false,
      'events':{"opted":[],"notOpted":[],"unSigned":[],"leave":[]},
    });
  }

static void updateEventsDb(String uId){
  print("hi");
  print(uId);
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');
     employeeCollection.doc(uId).update({'events':{"opted":["updated"],"notOpted":["updated"],"unSigned":[],"leave":[]}});
    }

static fetchUserData(String uId) async {
   final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection('employees');
     DocumentSnapshot  documentSnapshot= await employeeCollection.doc(uId).get();
     print(uId);
     print("snapshot ${documentSnapshot}");    
       if (documentSnapshot.exists) {
      // Convert document data to a Map<String, dynamic>
      Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
      print(" documentData ${documentData}");
      return documentData;
    } else {
      print('Document does not exist');
      return null;
    }
}

}

  
