import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/repositories/user_events_repo.dart';

class EmployeeHomeProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String, Map<String, dynamic>>> _floorDetails = [];
  int _radioValue = 1;
  bool _reasonEmpty = false;

  void setRadioValue(int? inValue) {
    _radioValue = inValue!;
    notifyListeners();
  }

  void setReasonEmpty(bool value) {
    _reasonEmpty = value;
    notifyListeners();
  }

  // aquires details of floor from db
  Future<void> setFloorDetails() async {
    _floorDetails = await _db.readFloors();
    notifyListeners();
  }

  int get getRadioValue => _radioValue;
  bool get getReasonEmpty => _reasonEmpty;
  List<Map<String, Map<String, dynamic>>> get getFloorDetails => _floorDetails;
}
