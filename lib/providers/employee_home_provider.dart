import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class EmployeeHomeProvider extends ChangeNotifier {
  final DatabaseServices _db = DatabaseServices();

  List<Map<String, Map<String, dynamic>>> _floorDetails = [];
  int _radioValue = 0;
  bool _reasonEmpty = false;

  // aquires details of floor from db
  Future<void> setFloorDetails() async {
    _floorDetails = await _db.readFloors();
    print(_floorDetails);
    notifyListeners();
  }

  // aquires details of events from db
  Future<void> setEventsInfo() async {
    // _eventsInfo = await _db.readEvents();
    notifyListeners();
  }

  void setRadioValue(int? inValue) {
    _radioValue = inValue!;
    notifyListeners();
  }

  void setReasonEmpty(bool value) {
    _reasonEmpty = value;
    notifyListeners();
  }

  // pushes date to db to opted or notOpted category
  Future<void> pushDate(
      {required DateTime date, required int radioValue, String? reason}) async {
    _db.pushDatetoDB(date: date, radioValue: radioValue, reason: reason);
  }

  int get getRadioValue => _radioValue;
  bool get getReasonEmpty => _reasonEmpty;
  List<Map<String, Map<String, dynamic>>> get getFloorDetails => _floorDetails;
}
