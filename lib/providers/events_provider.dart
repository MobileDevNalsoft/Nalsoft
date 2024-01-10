import 'package:flutter/material.dart';
import 'package:meals_management/Repositories/events_repo.dart';
import 'package:meals_management/Repositories/user_repo.dart';
import 'package:meals_management/views/modals/events_model.dart';


class EventsProvider extends ChangeNotifier {
  
  late EventsModel _eventModel;
 EventsRepo _eventsRepo= EventsRepo();

  String _reason='single day';

  String get reason=> _reason;
  void setReason(String value){
    _reason = value;
    notifyListeners();
  }

  void updateEvents(dates, String selectedReason,String uid) {
    
    if  (selectedReason!="vacation"){
      dates.forEach((date){
          _eventModel.notOpted!.add(date);
      });
      _eventsRepo.getEvents(uid);
  }
}
}