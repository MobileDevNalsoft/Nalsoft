import 'package:cloud_firestore/cloud_firestore.dart';

class EventsRepo{
  final _db = FirebaseFirestore.instance;

  Future<void> getEvents(String uid) async{
      DocumentSnapshot documentSnapshot= await _db.collection("employees").doc(uid).collection(uid).doc(uid).get() ;
      print(documentSnapshot);
      if (documentSnapshot.exists){
        print("yes");
      }
      else{
        print("no");
      }
      
      
  }
}