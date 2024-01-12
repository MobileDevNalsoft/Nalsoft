import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/views/models/events_model.dart';
import 'package:meals_management/views/models/user_model.dart';

class EventsRepo{
  final _db = FirebaseFirestore.instance;

  Future<void> getEvents(String uid) async{
      DocumentSnapshot documentSnapshot= await _db.collection("employees").doc(uid).collection("events").doc(uid).get() ;
      print(documentSnapshot);
      if (documentSnapshot.exists){
      // var eventsData=documentSnapshot.data();
      //   EventsModel(opted:eventsData["opted"]);
      EventsModel eventsModel=EventsModel.fromJson(documentSnapshot.data() as Map<String,dynamic>);
      print(eventsModel.opted);
      }
      else{
        print("no");
      }
      
      
  }

  void updateEvents(dates,String uid)  {
    // user.toJson(dates);
    
     print("events${EventsModel().toJson(dates)}");
    //  Map<String, dynamic> data=await EventsModel().toJson(dates);
    //  print("data${data}");
    //   await _db.collection("employees").doc(uid).collection("events").doc(uid).set(data) ;
    //   getEvents(uid);
  }

}