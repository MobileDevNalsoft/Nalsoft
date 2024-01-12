import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/Repositories/events_repo.dart';
// import 'package:meals_management/Repositories/user_repo.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/views/models/events_model.dart';


class EventsProvider extends ChangeNotifier {
  
  late EventsModel _eventModel;
 EventsRepo _eventsRepo= EventsRepo();

  String _reason='Single day';

  String get reason=> _reason;
  void setReason(String value){
    _reason = value;
    notifyListeners();
  }

  void updateEvents(dates, String selectedReason,String uid,AuthenticationProvider loginProvider) {
    print("inside provider");
    if  (selectedReason!="vacation"  && selectedReason!='Single day'){
      print("multiple days selected");
      print(dates[0].runtimeType);
      var notOptedList = dates.map((item) => Timestamp.fromDate(item)).toList();
      // get
      
      // _eventsRepo.updateEvents(dates,uid);
      // print("added");
      // _eventsRepo.getEvents(uid);
      notifyListeners();
  }
}
}