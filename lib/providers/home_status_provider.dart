import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class HomeStatusProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String, Map<String, dynamic>>> _floorDetails = [];
  bool _reasonStatusEmpty = false;
  String _selectedReason = 'Single day';

  void setReasonStatusEmpty(bool value) {
    _reasonStatusEmpty = value;
    notifyListeners();
  }

  void setReason(String value) {
    _selectedReason = value;
    notifyListeners();
  }

  // aquires details of floor from db
  Future<void> setFloorDetails() async {
    _floorDetails = await _db.readFloors();
    notifyListeners();
  }

  bool get getReasonStatusEmpty => _reasonStatusEmpty;
  String get getReason => _selectedReason;
  List<Map<String, Map<String, dynamic>>> get getFloorDetails => _floorDetails;
}
